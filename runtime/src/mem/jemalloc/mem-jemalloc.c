/*
 * Copyright 2020-2025 Hewlett Packard Enterprise Development LP
 * Copyright 2004-2019 Cray Inc.
 * Other additional copyright holders may be indicated within.
 *
 * The entirety of this work is licensed under the Apache License,
 * Version 2.0 (the "License"); you may not use this file except
 * in compliance with the License.
 *
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

#include "chplrt.h"

#include <pthread.h>
#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>
#include <string.h>

#include "chpl-comm.h"
#include "chpl-env.h"
#include "chpl-linefile-support.h"
#include "chpl-mem.h"
#include "chpl-mem-desc.h"
#include "chpl-topo.h"
#include "chplcgfns.h"
#include "chplmemtrack.h"
#include "chpltypes.h"
#include "error.h"

static chpl_bool interleave_mem = false;
static chpl_bool merge_split_chunks = false;

// The dedicated arena to use for large allocations (this is important to
// minimize contention for large allocations)
unsigned CHPL_JE_LG_ARENA;

// Decide whether or not to try to use jemalloc's chunk hooks interface
//   jemalloc < 4.0 didn't support chunk_hooks_t
//   jemalloc 4.1 changed opt.nareas from size_t to unsigned
//   jemalloc 5.x migrated to an extent API
// .. so we use chunk hooks interface for jemalloc >= 4.1 and < 5.0
#if (JEMALLOC_VERSION_MAJOR == 4) && (JEMALLOC_VERSION_MINOR >= 1)
#define USE_JE_CHUNK_HOOKS
#endif
#if JEMALLOC_VERSION_MAJOR >= 5
#define USE_JE_EXTENT_HOOKS
#endif

enum heap_type {FIXED, DYNAMIC, NONE};

static struct shared_heap {
  enum heap_type type;
  void* base;
  size_t size;
  size_t cur_offset;
  pthread_mutex_t alloc_lock;
} heap;


#if defined(USE_JE_CHUNK_HOOKS) || defined(USE_JE_EXTENT_HOOKS)
// compute aligned index into our shared heap, alignment must be a power of 2
static inline void* alignHelper(void* base_ptr, size_t offset, size_t alignment) {
  uintptr_t p;

  assert(alignment && ((alignment & (alignment -1)) == 0));
  p = (uintptr_t)base_ptr + offset;
  p = (p + alignment - 1) & ~(alignment - 1);
  return(void*) p;
}
#endif


// *** Chunk hook replacements *** //
// See http://www.canonware.com/download/jemalloc/jemalloc-latest/doc/jemalloc.html#arena.i.chunk_hooks

// avoid unused function warnings by only defining these chunk hooks
// if they could be used
#ifdef USE_JE_CHUNK_HOOKS


// Our chunk replacement hook for allocations (Essentially a replacement for
// mmap/sbrk.) Grab memory out of the fixed shared heap or get an extension
// chunk, and give it to jemalloc.
static void* chunk_alloc(void *chunk, size_t size, size_t alignment, bool *zero, bool *commit, unsigned arena_ind) {

  void* cur_chunk_base = NULL;

  if (heap.type == FIXED) {
    //
    // Get more space out of the fixed heap.
    //
    size_t cur_heap_size;

    // this function can be called concurrently and it looks like jemalloc
    // doesn't call it inside a lock, so we need to protect it ourselves
    pthread_mutex_lock(&heap.alloc_lock);

    // compute our current aligned pointer into the shared heap
    //
    //   jemalloc 4.5.0 man: "The alignment parameter is always a power of two
    //   at least as large as the chunk size."
    cur_chunk_base = alignHelper(heap.base, heap.cur_offset, alignment);

    // jemalloc 4.5.0 man: "If chunk is not NULL, the returned pointer must be
    // chunk on success or NULL on error"
    if (chunk && chunk != cur_chunk_base) {
      pthread_mutex_unlock(&heap.alloc_lock);
      return NULL;
    }

    cur_heap_size = (uintptr_t)cur_chunk_base - (uintptr_t)heap.base;

    // If there's not enough space on the heap for this allocation, return NULL
    if (size > heap.size - cur_heap_size) {
      pthread_mutex_unlock(&heap.alloc_lock);
      return NULL;
    }

    // Update the current pointer, now that we've past any early returns.
    heap.cur_offset = cur_heap_size + size;

    // now that cur_heap_offset is updated, we can unlock
    pthread_mutex_unlock(&heap.alloc_lock);

    if (interleave_mem && arena_ind == CHPL_JE_LG_ARENA) {
      chpl_topo_interleaveMemLocality(cur_chunk_base, size);
    }
  } else if (heap.type == DYNAMIC) {
    // jemalloc 4.5.0 man: "If chunk is not NULL, the returned pointer must be
    // chunk on success or NULL on error". This is used to grab new chunks in a
    // specific location so they can be merged with old ones for in-place
    // reallocation. It's unlikely our allocation will happen to get the right
    // address so don't waste time allocating/freeing in the common case.
    if (chunk != NULL) {
      return NULL;
    }

    //
    // Get a dynamic extension chunk.
    //
    cur_chunk_base = chpl_comm_regMemAlloc(size, CHPL_RT_MD_MEM_HEAP_SPACE,
                                           0, CHPL_FILE_IDX_INTERNAL);

    if (cur_chunk_base == NULL) {
      return NULL;
    }

    assert(((uintptr_t)cur_chunk_base & (alignment-1)) == 0);

    //
    // Localize the new memory via first-touch, by storing to each page.
    // This will give the memory affinity to the NUMA domain (if any)
    // we were running on when we allocated it.  It also commits the
    // memory, in the jemalloc sense.
    //
    const size_t heap_page_size = chpl_comm_regMemHeapPageSize();
    for (int i = 0; i < size; i += heap_page_size) {
      ((char*) cur_chunk_base)[i] = 0;
    }

    chpl_comm_regMemPostAlloc(cur_chunk_base, size);

    // Support useUpMemNotInHeap by hiding the fixed/dynamic distinction
    heap.base = cur_chunk_base;
    heap.size = size;
    heap.cur_offset = 0;
  } else {
    chpl_internal_error("Invalid heap.type in chunk_alloc");
  }

  // jemalloc 4.5.0 man: "Zeroing is mandatory if *zero is true upon entry."
  if (*zero) {
    memset(cur_chunk_base, 0, size);
  }

  // Commit is not relevant for linux/darwin, but jemalloc wants us to set it
  *commit = true;

  return cur_chunk_base;
}

//
// Returning true indicates an opt-out of these hooks. For dalloc, this means
// that we never get memory back from jemalloc and we just let it re-use it in
// the future.
//
static bool null_dalloc(void *chunk, size_t size, bool committed, unsigned arena_ind) {
  return true;
}
static bool null_commit(void *chunk, size_t size, size_t offset, size_t length, unsigned arena_ind) {
  return true;
}
static bool null_decommit(void *chunk, size_t size, size_t offset, size_t length, unsigned arena_ind) {
  return true;
}
static bool null_purge(void *chunk, size_t size, size_t offset, size_t length, unsigned arena_ind) {
  return true;
}


// Since we opt-out of dalloc hooks, jemalloc is free to merge/split existing
// chunks (this is important for fragmentation avoidance.) If we support dalloc
// we'll have to do more to update how we track backing memory regions. Note
// that returning false means splitting/merging is allowed.
static bool chunk_split(void *chunk, size_t size, size_t size_a, size_t size_b, bool committed, unsigned arena_ind) {
  return !merge_split_chunks;
}
static bool chunk_merge(void *chunk_a, size_t size_a, void *chunk_b, size_t size_b, bool committed, unsigned arena_ind) {
  return !merge_split_chunks;
}

#endif // ifdef USE_JE_CHUNK_HOOKS


#ifdef USE_JE_EXTENT_HOOKS


// Our extent replacement hook for allocations (Essentially a replacement for
// mmap/sbrk.) Grab memory out of the fixed shared heap or get an extension
// chunk, and give it to jemalloc.
static void* extent_alloc(
  extent_hooks_t *extent_hooks,
  void *new_addr, size_t size, size_t alignment,
  bool *zero, bool *commit, unsigned arena_ind) {

  void* cur_extent_base = NULL;

  if (heap.type == FIXED) {
    //
    // Get more space out of the fixed heap.
    //
    size_t cur_heap_size;

    // this function can be called concurrently and it looks like jemalloc
    // doesn't call it inside a lock, so we need to protect it ourselves
    pthread_mutex_lock(&heap.alloc_lock);

    // compute our current aligned pointer into the shared heap
    //
    //   jemalloc 5.3.0 man: "The alignment parameter is always a power of two at least as large as the page size."
    cur_extent_base = alignHelper(heap.base, heap.cur_offset, alignment);

    // jemalloc 5.3.0 man: " If new_addr is not NULL, the returned pointer must be new_addr on success or NULL on error."
    if (new_addr && new_addr != cur_extent_base) {
      pthread_mutex_unlock(&heap.alloc_lock);
      return NULL;
    }

    cur_heap_size = (uintptr_t)cur_extent_base - (uintptr_t)heap.base;

    // If there's not enough space on the heap for this allocation, return NULL
    if (size > heap.size - cur_heap_size) {
      pthread_mutex_unlock(&heap.alloc_lock);
      return NULL;
    }

    // Update the current pointer, now that we've past any early returns.
    heap.cur_offset = cur_heap_size + size;

    // now that cur_heap_offset is updated, we can unlock
    pthread_mutex_unlock(&heap.alloc_lock);

    if (interleave_mem && arena_ind == CHPL_JE_LG_ARENA) {
      chpl_topo_interleaveMemLocality(cur_extent_base, size);
    }
  } else if (heap.type == DYNAMIC) {
    // jemalloc 5.3.0 man: "If new_addr is not NULL, the returned pointer must be new_addr on success or NULL on error". This is used to grab new chunks in a
    // specific location so they can be merged with old ones for in-place
    // reallocation. It's unlikely our allocation will happen to get the right
    // address so don't waste time allocating/freeing in the common case.
    if (new_addr != NULL) {
      return NULL;
    }

    //
    // Get a dynamic extension chunk.
    //
    cur_extent_base = chpl_comm_regMemAlloc(size, CHPL_RT_MD_MEM_HEAP_SPACE,
                                           0, CHPL_FILE_IDX_INTERNAL);

    if (cur_extent_base == NULL) {
      return NULL;
    }

    assert(((uintptr_t)cur_extent_base & (alignment-1)) == 0);

    //
    // Localize the new memory via first-touch, by storing to each page.
    // This will give the memory affinity to the NUMA domain (if any)
    // we were running on when we allocated it.  It also commits the
    // memory, in the jemalloc sense.
    //
    const size_t heap_page_size = chpl_comm_regMemHeapPageSize();
    for (int i = 0; i < size; i += heap_page_size) {
      ((char*) cur_extent_base)[i] = 0;
    }

    chpl_comm_regMemPostAlloc(cur_extent_base, size);

    // Support useUpMemNotInHeap by hiding the fixed/dynamic distinction
    heap.base = cur_extent_base;
    heap.size = size;
    heap.cur_offset = 0;
  } else {
    chpl_internal_error("Invalid heap.type in extent_alloc");
  }

  // jemalloc 5.3.0 man: "Zeroing is mandatory if *zero is true upon function entry."
  if (*zero) {
    memset(cur_extent_base, 0, size);
  }

  // Commit is not relevant for linux/darwin, but jemalloc wants us to set it
  *commit = true;

  return cur_extent_base;
}

//
// Returning true indicates an opt-out of these hooks. For dalloc, this means
// that we never get memory back from jemalloc and we just let it re-use it in
// the future.
//
static bool extent_dalloc(
  extent_hooks_t *extent_hooks,
  void *addr, size_t size, bool committed, unsigned arena_ind) {
  return true;
}

static void extent_destroy(
  extent_hooks_t *extent_hooks,
  void *addr, size_t size, bool committed, unsigned arena_ind) {
  // Do nothing to destroy the extent
}

static bool extent_commit(extent_hooks_t *extent_hooks,
  void *addr, size_t size, size_t offset, size_t length, unsigned arena_ind) {
  return true;
}
static bool extent_decommit(extent_hooks_t *extent_hooks,
  void *addr, size_t size, size_t offset, size_t length, unsigned arena_ind) {
  return true;
}
static bool extent_purge(
  extent_hooks_t *extent_hooks,
  void *addr, size_t size, size_t offset, size_t length, unsigned arena_ind) {
  return true;
}

// Since we opt-out of dalloc hooks, jemalloc is free to merge/split existing
// chunks (this is important for fragmentation avoidance.) If we support dalloc
// we'll have to do more to update how we track backing memory regions. Note
// that returning false means splitting/merging is allowed.
static bool extent_split(
  extent_hooks_t *extent_hooks,
  void *addr, size_t size, size_t size_a, size_t size_b,
  bool committed, unsigned arena_ind) {
  return !merge_split_chunks;
}
static bool extent_merge(
  extent_hooks_t *extent_hooks,
  void *addr_a, size_t size_a, void *addr_b, size_t size_b,
  bool committed, unsigned arena_ind) {
  return !merge_split_chunks;
}

#endif // ifdef USE_JE_EXTENT_HOOKS

// *** End chunk hook replacements *** //


// helper routine to get a mallctl value
#define DECLARE_GET_MALLCTL_VALUE(type) \
static type get_ ## type ##_mallctl_value(const char* mallctl_string) { \
  type value; \
  size_t sz; \
  sz = sizeof(value); \
  if (CHPL_JE_MALLCTL(mallctl_string, &value, &sz, NULL, 0) != 0) { \
    char error_msg[256]; \
    snprintf(error_msg, sizeof(error_msg), "could not get mallctl value for %s", mallctl_string); \
    chpl_internal_error(error_msg); \
  } \
  return value; \
}
DECLARE_GET_MALLCTL_VALUE(size_t);
DECLARE_GET_MALLCTL_VALUE(unsigned);
#undef DECLARE_GET_MALLCTL_VALUE


// get the number of arenas
static unsigned get_num_arenas(void) {
  return get_unsigned_mallctl_value("opt.narenas");
}

// set the current threads arena
static void set_arena(unsigned arena) {
  if (CHPL_JE_MALLCTL("thread.arena", NULL, NULL, &arena, sizeof(arena)) != 0) {
    chpl_internal_error("could not change current thread's arena");
  }
}

// initialize our arenas (this is required to be able to set the chunk hooks)
static void initialize_arenas(void) {
  unsigned narenas;
  unsigned arena;

  // for each non-zero arena, set the current thread to use it (this
  // initializes each arena). arena 0 is automatically initialized.
  //
  //   jemalloc 4.5.0 man: "If the specified arena was not initialized
  //   beforehand, it will be automatically initialized as a side effect of
  //   calling this interface."
  narenas = get_num_arenas();
  for (arena=1; arena<narenas; arena++) {
    set_arena(arena);
  }

  // then set the current thread back to using arena 0
  set_arena(0);
}

#ifdef USE_JE_EXTENT_HOOKS
// the memory of new_hooks must last beyond the call to replaceChunkHooks
static extent_hooks_t new_hooks = {
  extent_alloc,
  extent_dalloc,
  extent_destroy,
  extent_commit,
  extent_decommit,
  extent_purge, // lazy purge
  extent_purge, // forced purge
  extent_split,
  extent_merge
};
#endif

// replace the chunk hooks for each arena with the hooks we provided above
static void replaceChunkHooks(void) {

// we can't use chunk hooks for older versions of jemalloc
#ifdef USE_JE_CHUNK_HOOKS

  unsigned narenas;
  unsigned arena;

  // set the pointers for the new_hooks to our above functions
  chunk_hooks_t new_hooks = {
    chunk_alloc,
    null_dalloc,
    null_commit,
    null_decommit,
    null_purge,
    chunk_split,
    chunk_merge
  };

  // for each arena, change the chunk hooks
  narenas = get_num_arenas();
  for (arena=0; arena<narenas; arena++) {
    char path[128];
    snprintf(path, sizeof(path), "arena.%u.chunk_hooks", arena);
    if (CHPL_JE_MALLCTL(path, NULL, NULL, &new_hooks, sizeof(chunk_hooks_t)) != 0) {
      chpl_internal_error("could not update the chunk hooks");
    }
  }
#else
#ifdef USE_JE_EXTENT_HOOKS

  unsigned narenas;
  unsigned arena;

  // for each arena, change the chunk hooks
  narenas = get_num_arenas();
  for (arena=0; arena<narenas; arena++) {
    char path[128];
    snprintf(path, sizeof(path), "arena.%u.extent_hooks", arena);

    extent_hooks_t* hooks = &new_hooks;
    if (CHPL_JE_MALLCTL(path, NULL, NULL, &hooks, sizeof(hooks)) != 0) {
      chpl_internal_error_v("could not update the extent hooks");
    }
  }

#else
    chpl_internal_error("cannot init multi-locale heap");
#endif
#endif

}

// helper routines to get the number of size classes
static unsigned get_num_small_classes(void) {
  return get_unsigned_mallctl_value("arenas.nbins");
}

static unsigned get_num_large_classes(void) {
#ifdef USE_JE_EXTENT_HOOKS
  return get_unsigned_mallctl_value("arenas.nlextents");
#else
  return get_unsigned_mallctl_value("arenas.nlruns");
#endif
}

static unsigned get_num_small_and_large_classes(void) {
  return get_num_small_classes() + get_num_large_classes();
}

// helper routine to get an array of size classes for small and large sizes
static void get_small_and_large_class_sizes(size_t* classes) {
  unsigned class;
  unsigned small_classes;
  unsigned large_classes;

  small_classes = get_num_small_classes();
  for (class=0; class<small_classes; class++) {
    char ssize[128];
    snprintf(ssize, sizeof(ssize), "arenas.bin.%u.size", class);
    classes[class] = get_size_t_mallctl_value(ssize);
  }

  large_classes = get_num_large_classes();
  for (class=0; class<large_classes; class++) {
    char lsize[128];
#ifdef USE_JE_EXTENT_HOOKS
    snprintf(lsize, sizeof(lsize), "arenas.lextent.%u.size", class);
#else
    snprintf(lsize, sizeof(lsize), "arenas.lrun.%u.size", class);
#endif
    classes[small_classes + class] = get_size_t_mallctl_value(lsize);
  }
}

// helper routine to determine if an address is not part of the shared heap
static chpl_bool addressNotInHeap(void* ptr) {
  uintptr_t u_ptr = (uintptr_t)ptr;
  uintptr_t u_base = (uintptr_t)heap.base;
  uintptr_t u_top = u_base + heap.size;
  return (u_ptr < u_base) || (u_ptr >= u_top);
}

// grab (and leak) whatever memory jemalloc got on it's own, that's not in
// our shared heap
//
//   jemalloc 4.5.0 man: "arenas may have already created chunks prior to the
//   application having an opportunity to take over chunk allocation."
//
// jemalloc grabs "chunks" from the system in order to store metadata and some
// internal data structures. However, these chunks are not allocated from our
// shared heap, so we need to waste whatever memory is left in them so that
// future allocations come from chunks that were provided by our shared heap
static void useUpMemNotInHeap(void) {
  unsigned class;
  unsigned num_classes = get_num_small_and_large_classes();
  size_t classes[num_classes];
  get_small_and_large_class_sizes(classes);

  // jemalloc has 3 class sizes. The small (a few pages) and large (up to chunk
  // size) objects come from the arenas, but huge (more than chunk size)
  // objects comes from a shared pool. We waste memory at every large and small
  // class size so that we can be sure there's no fragments left in a chunk
  // that jemalloc grabbed from the system. This way we know that any future
  // allocation, regardless of size, must have come from a chunk provided by
  // our shared heap. Once we know a specific class size came from our shared
  // heap, we can free the memory instead of leaking it.
#ifdef USE_JE_EXTENT_HOOKS
  // with extent hooks, there are some really large classes that can cause
  // segfaults, so we start from the last small class and go down
  unsigned large_classes = get_num_large_classes();
  unsigned start_point = num_classes - 1 - large_classes;
#else
  unsigned start_point = num_classes - 1;
#endif

  for (class=start_point; class!=UINT_MAX; class--) {
    void* p = NULL;
    size_t alloc_size;
    alloc_size = classes[class];
    do {
      if ((p = CHPL_JE_MALLOCX(alloc_size, MALLOCX_NO_FLAGS)) == NULL) {
        chpl_internal_error("could not use up memory outside of shared heap");
      }
    } while (addressNotInHeap(p));
    CHPL_JE_DALLOCX(p, MALLOCX_NO_FLAGS);
  }
}

// Have jemalloc use our shared heap. Initialize all the arenas, then replace
// the chunk hooks with our custom ones, and finally use up any memory jemalloc
// got from the system that's not in our shared heap.
static void initializeSharedHeap(void) {
  initialize_arenas();

  replaceChunkHooks();

  useUpMemNotInHeap();

  // printf("trying to do an allocagion\n");
  // void* p = CHPL_JE_MALLOCX(2 * 1024 * 1024, MALLOCX_NO_FLAGS);
  // printf("got %p\n", p);

  // printf("trying to do an allocagion\n");
  // p = CHPL_JE_MALLOCX(57344, MALLOCX_NO_FLAGS);
  // printf("got %p\n", p);
}

void chpl_mem_layerInit(void) {
  void* heap_base;
  size_t heap_size;

  interleave_mem = chpl_env_rt_get_bool("INTERLEAVE_MEMORY", CHPL_INTERLEAVE_MEM);
  CHPL_JE_LG_ARENA = get_num_arenas()-1;

  chpl_comm_regMemHeapInfo(&heap_base, &heap_size);
  if (heap_base != NULL && heap_size == 0) {
    chpl_internal_error("if heap address is specified, size must be also");
  }

  // If we have a fixed shared heap, initialize it. This will take care
  // of initializing jemalloc. Otherwise, do a first allocation to allow
  // jemalloc to set up. Note that if we have a dynamic shared heap this
  // will initialize that including adding the first chunk to it.
  //
  //   jemalloc 4.5.0 man: "Once, when the first call is made to one of the
  //   memory allocation routines, the allocator initializes its internals"
  if (heap_base != NULL) {
    heap.type = FIXED;
    // With a fixed heap all memory should be registered together so
    // merging/splitting is allowed
    merge_split_chunks = chpl_env_rt_get_bool("MERGE_SPLIT_CHUNKS", true);
    heap.base = heap_base;
    heap.size = heap_size;
    heap.cur_offset = 0;
    if (pthread_mutex_init(&heap.alloc_lock, NULL) != 0) {
      chpl_internal_error("cannot init chunk_alloc lock");
    }
    initializeSharedHeap();
  } else if (chpl_comm_regMemAllocThreshold() < SIZE_MAX) {
    heap.type = DYNAMIC;
    // With a dynamic heap, extensions can be split, but merging may not work
    // since we'd have a single blob of memory covered by multiple registration
    // regions, which our comm layers may not support.
    merge_split_chunks = chpl_env_rt_get_bool("MERGE_SPLIT_CHUNKS", false);
    initializeSharedHeap();
  } else {
    void* p;
    heap.type = NONE;
    if ((p = CHPL_JE_MALLOCX(1, MALLOCX_NO_FLAGS)) == NULL) {
      chpl_internal_error("cannot init heap: chpl_je_malloc() failed");
    }
    CHPL_JE_DALLOCX(p, MALLOCX_NO_FLAGS);
  }
}


void chpl_mem_layerExit(void) {
  if (heap.type == FIXED) {
    // ignore errors, we're exiting anyways
    (void) pthread_mutex_destroy(&heap.alloc_lock);
  }
}
