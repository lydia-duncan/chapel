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

module ChapelDistribution {

  use ChapelArray, ChapelRange;
  use ChapelLocks;
  use ChapelHashtable;

  //
  // Distribution wrapper record
  //
  pragma "distribution"
  pragma "ignore noinit"
  @chpldoc.nodoc
  record _distribution : writeSerializable, readDeserializable {
    var _pid:int;  // only used when privatized
    pragma "owned"
    var _instance; // generic, but an instance of a subclass of BaseDist
    var _unowned:bool; // 'true' for the result of 'getDistribution',
                       // in which case, the record destructor should
                       // not attempt to delete the _instance.

    proc init(_pid : int, _instance, _unowned : bool) {
      this._pid      = _pid;
      this._instance = _instance;
      this._unowned  = _unowned;
    }

    proc init(value) {
      this._pid = if _isPrivatized(value) then _newPrivatizedClass(value) else nullPid;
      this._instance = _to_unmanaged(value);
    }

    // Note: This does not handle the case where the desired type of 'this'
    // does not match the type of 'other'. That case is handled by the compiler
    // via coercions.
    proc init=(const ref other : _distribution) {
      var value = other._value.dsiClone();
      this.init(value);
    }

    inline proc _value {
      if _isPrivatized(_instance) {
        return chpl_getPrivatizedCopy(_instance.type, _pid);
      } else {
        return _instance;
      }
    }

    forwarding _value except targetLocales;

    inline proc _do_destroy() {
      if ! _unowned && ! _instance.singleton() {
        on _instance {
          // Count the number of domains that refer to this distribution.
          // and mark the distribution to be freed when that number reaches 0.
          // If the number is 0, .remove() returns the distribution
          // that should be freed.
          var distToFree = _instance.remove();
          if distToFree != nil {
            _delete_dist(distToFree!, _isPrivatized(_instance));
          }
        }
      }
    }

    proc deinit() {
      _do_destroy();
    }

    proc clone() {
      return new _distribution(_value.dsiClone());
    }

    proc newRectangularDom(param rank: int, type idxType,
                           param strides: strideKind,
                           ranges: rank*range(idxType, boundKind.both, strides),
                           definedConst: bool = false) {
      var x = _value.dsiNewRectangularDom(rank, idxType, strides, ranges);

      x.definedConst = definedConst;

      if x.linksDistribution() {
        _value.add_dom(x);
      }
      return x;
    }

    proc newRectangularDom(param rank: int, type idxType,
                           param strides: strideKind,
                           definedConst: bool = false) {
      var ranges: rank*range(idxType, boundKind.both, strides);
      return newRectangularDom(rank, idxType, strides, ranges, definedConst);
    }

    proc newAssociativeDom(type idxType, param parSafe: bool=true) {
      var x = _value.dsiNewAssociativeDom(idxType, parSafe);
      if x.linksDistribution() {
        _value.add_dom(x);
      }
      return x;
    }

    proc newSparseDom(param rank: int, type idxType, dom: domain) {
      var x = _value.dsiNewSparseDom(rank, idxType, dom);
      if x.linksDistribution() {
        _value.add_dom(x);
      }
      return x;
    }

    proc idxToLocale(ind) do return _value.dsiIndexToLocale(ind);

    @chpldoc.nodoc
    proc ref deserialize(reader, ref deserializer) throws {
      reader.read(_value);
    }

    // TODO: Can't this be an initializer?
    @chpldoc.nodoc
    proc type deserializeFrom(reader, ref deserializer) throws {
      var ret : this;
      ret.deserialize(reader, deserializer);
      return ret;
    }

    @chpldoc.nodoc
    proc serialize(writer, ref serializer) throws {
      writer.write(_value);
    }

    proc displayRepresentation() { _value.dsiDisplayRepresentation(); }

    /*
       Return an array of locales over which this distribution was declared.
    */
    proc targetLocales() const ref {
      return _value.dsiTargetLocales();
    }
  }  // record _distribution

  //
  // Abstract distribution class
  //
  pragma "base dist"
  class BaseDist {
    var _doms_containing_dist: int; // number of domains using this distribution
    var _domsLock: chpl_LocalSpinlock; // lock for concurrent access
    var _free_when_no_doms: bool; // true when original _distribution is destroyed
    var pid:int = nullPid; // privatized ID, if privatization is supported

    proc deinit() {
    }

    // Returns a distribution that should be freed or nil.
    pragma "dont disable remote value forwarding"
    proc remove(): unmanaged BaseDist? {
      var free_dist = false;
      if dsiTrackDomains() {
        on this {
          var dom_count = -1;
          local {
            _domsLock.lock();
            // Set a flag to indicate it should be freed when _doms
            // becomes empty
            _free_when_no_doms = true;
            dom_count = _doms_containing_dist;
            _domsLock.unlock();
          }
          if dom_count == 0 then
            free_dist = true;
        }
      } else {
        // if we're not tracking domains, always free the
        // distribution when it goes out of scope.
        free_dist = true;
      }
      if free_dist then
        return _to_unmanaged(this);
      else
        return nil;
    }

    // Returns true if the distribution should be removed.
    inline proc remove_dom(x:unmanaged BaseDom): bool {
      var count = -1;
      on this {
        var cnt = -1;
        local {
          _domsLock.lock();
          _doms_containing_dist -= 1;
          cnt = _doms_containing_dist;

          // add one for the main distribution instance
          if !_free_when_no_doms then
            cnt += 1;

          _domsLock.unlock();
        }
        count = cnt;
      }
      return (count==0);
    }

    //
    // TODO: There may be some opportunities to optimize out the
    // locking here, as in the add_arr() case.  For example, the
    // construction of the distribution and domain used for rank change
    // slicing could use an unlocked version because that operation
    // creates a new distribution followed immediately by a domain
    // over the distribution. It's unclear how important this
    // optimization is, though, because rank change slices are
    // arguably less common (and already more expensive in most cases
    // due to the creation of distribution and domain objects) than
    // rank-preserving slicing.
    //
    inline proc add_dom(x:unmanaged BaseDom) {
      on this {
        _domsLock.lock();
        _doms_containing_dist += 1 ;
        _domsLock.unlock();
      }
    }

    proc dsiDisplayRepresentation() {
      writeln("<no way to display representation>");
    }

    pragma "last resort" @chpldoc.nodoc
    proc dsiNewRectangularDom(param rank: int, type idxType,
                              param strides: strideKind, inds) {
      compilerError("rectangular domains not supported by this distribution");
    }

    pragma "last resort" @chpldoc.nodoc
    proc dsiNewAssociativeDom(type idxType, param parSafe: bool) {
      compilerError("associative domains not supported by this distribution");
    }

    pragma "last resort" @chpldoc.nodoc
    proc dsiNewSparseDom(param rank: int, type idxType, dom: domain) {
      compilerError("sparse domains not supported by this distribution");
    }

    proc dsiSupportsPrivatization() param do return false;
    proc dsiRequiresPrivatization() param do return false;

    proc dsiDestroyDist() { }

    // Does the distribution keep a list of domains? Can the domains
    // keep the distribution alive longer? false for DefaultDist.
    proc trackDomains() param do return true;

    // dynamically-dispatched counterpart of linksDistribution
    proc dsiTrackDomains() do return true;

    // indicates if a distribution is a singleton. If so, we make no
    // effort to free it. DefaultDist is a singleton.
    proc singleton() param do return false;
    // We could add dsiSingleton as a dynamically-dispatched counterpart

    // indicates if this distribution is a layout. This helps
    // with certain warnings.
    proc dsiIsLayout() param do return false;
  }

  //
  // Abstract domain classes
  //
  pragma "base domain"
  class BaseDom {
    // Head pointer to doubly-linked-list of arrays declared over this domain.
    // Only used when trackArrays() is true. Instead of having an external list
    // data structure, we just store the prev/next pointers directly in BaseArr
    var _arrs_head: unmanaged BaseArr?;
    var _arrs_containing_dom: int; // number of arrays using this domain
                                   // as var A: [D] [1..2] real
                                   // is using {1..2}
    var _arrsLock: chpl_LocalSpinlock; // lock for concurrent access
    var _free_when_no_arrs: bool;
    var pid:int = nullPid; // privatized ID, if privatization is supported

    var definedConst: bool;

    proc init() {
    }

    proc deinit() {
    }

    iter _arrs: unmanaged BaseArr {
      var tmp = _arrs_head;
      while tmp != nil {
        yield tmp!;
        tmp = tmp!.next;
      }
    }

    proc dsiMyDist(): unmanaged BaseDist {
      halt("internal error: dsiMyDist is not implemented");
    }

    // default overloads to provide clear compile-time error messages

    proc dnsError(param op: string) {
      compilerError("this domain type does not support '", op, "'");
    }

    pragma "last resort" @chpldoc.nodoc
    proc dsiLow                   { dnsError("low"); }

    pragma "last resort" @chpldoc.nodoc
    proc dsiHigh                  { dnsError("high"); }

    pragma "last resort" @chpldoc.nodoc
    proc dsiAlignedLow            { dnsError("alignedLow"); }

    pragma "last resort" @chpldoc.nodoc
    proc dsiAlignedHigh           { dnsError("alignedHigh"); }

    pragma "last resort" @chpldoc.nodoc
    proc dsiFirst                 { dnsError("first"); }

    pragma "last resort" @chpldoc.nodoc
    proc dsiLast                  { dnsError("last"); }

    pragma "last resort" @chpldoc.nodoc
    proc dsiStride                { dnsError("stride"); }

    pragma "last resort" @chpldoc.nodoc
    proc dsiAlignment             { dnsError("alignment"); }

    pragma "last resort" @chpldoc.nodoc
    proc dsiIndexOrder(i)         { dnsError("indexOrder"); }

    pragma "last resort" @chpldoc.nodoc
    proc dsiCreateIndexBuffer(size) { dnsError("createIndexBuffer"); }

    // end of default overloads to provide clear compile-time error messages

    inline proc trackArrays() {
      return disableConstDomainOpt || !this.definedConst;
    }

    // Returns (dom, dist).
    // if this domain should be deleted, dom=this; otherwise it is nil.
    // dist is nil or a distribution that should be removed.
    pragma "dont disable remote value forwarding"
    proc remove() : (unmanaged BaseDom?, unmanaged BaseDist?) {

      if boundsChecking {
        // TODO -- remove dsiLinksDistribution
        assert( dsiMyDist().dsiTrackDomains() == dsiLinksDistribution() );
      }

      var ret_dom:unmanaged BaseDom? = nil;
      var ret_dist:unmanaged BaseDist? = nil;
      var dist = dsiMyDist();
      var free_dom = false;
      var remove_dist = false;
      on this {
        var arr_count = 0;
        // Count the number of arrays using this domain
        // and mark this domain to free itself when that number reaches 0.
        local {
          _arrsLock.lock();
          arr_count = _arrs_containing_dom;
          _free_when_no_arrs = true;
          _arrsLock.unlock();
        }

        if arr_count == 0 {
          free_dom = true;

          if dsiLinksDistribution() {
            // Remove the domain from the distribution
            // and find out if the distribution should be removed.
            remove_dist = dist.remove_dom(_to_unmanaged(this));
          }
        }
      }
      if free_dom then
        ret_dom = _to_unmanaged(this); // caller will delete this
      if remove_dist then
        ret_dist = dist; // caller will remove dist
      return (ret_dom, ret_dist);
    }

    // returns true if the domain should be removed
    // 'rmFromList' indicates whether this is an array that we've been
    // storing in the _arrs linked list or not (just counting it).
    // Currently, only slices using existing domains avoid the list.
    inline proc remove_arr(x:unmanaged BaseArr, param rmFromList=true): bool {
      var count = -1;
      on this {
        var cnt = -1;
        _arrsLock.lock();
        _arrs_containing_dom -=1;
        if rmFromList && trackArrays() {
          if _arrs_head == x then _arrs_head = x.next;
          if const xnext = x.next then xnext.prev = x.prev;
          if const xprev = x.prev then xprev.next = x.next;
        }
        cnt = _arrs_containing_dom;
        // add one for the main domain record
        if !_free_when_no_arrs then
          cnt += 1;
        _arrsLock.unlock();
        count = cnt;
      }
      return (count==0);
    }

    // addToList indicates whether this array should be added to the
    // '_arrs' linked list, or just counted.  At present, slice views
    // are not added to the linked list because they don't need to be
    // resized when their domain is re-assigned).
    inline proc add_arr(x:unmanaged BaseArr, param locking=true,
                        param addToList = true) {
      on this {
        if locking then
          _arrsLock.lock();
        _arrs_containing_dom += 1;
        if addToList && trackArrays() {
          assert (x.prev == nil && x.next == nil);
          if const ahead = _arrs_head {
            x.next = ahead;
            ahead.prev = x;
          }
          _arrs_head = x;
        }
        if locking then
          _arrsLock.unlock();
      }
    }

    // returns true if the domain should be removed
    inline proc remove_containing_arr(x:unmanaged BaseArr) {
      var count = -1;
      on this {
        var cnt = -1;
        _arrsLock.lock();
        _arrs_containing_dom -= 1;
        cnt = _arrs_containing_dom;
        // add one for the main domain record
        if !_free_when_no_arrs then
          cnt += 1;
        _arrsLock.unlock();

        count = cnt;
      }

      return (count==0);
    }

    inline proc add_containing_arr(x:unmanaged BaseArr) {
      on this {
        _arrsLock.lock();
        _arrs_containing_dom += 1;
        _arrsLock.unlock();
      }
    }

    proc dsiSupportsPrivatization() param do return false;
    proc dsiRequiresPrivatization() param do return false;

    // Does the distribution keep a list of domains? Can the
    // domains keep the distribution alive longer?
    proc linksDistribution() param do return true;

    // dynamically-dispatched counterpart of linksDistribution
    proc dsiLinksDistribution() do return true;

    // Overload to to customize domain destruction
    proc dsiDestroyDom() { }

    proc dsiDisplayRepresentation() { writeln("<no way to display representation>"); }

    proc dsiSupportsAutoLocalAccess() param {
      return false;
    }

    proc dsiSupportsOffsetAutoLocalAccess() param {
      return false;
    }

    proc dsiAutoLocalAccessOffsetCheck(offsets) {
      return false;
    }

    proc dsiSupportsArrayViewElision() param {
      return false;
    }

    proc dsiSupportsShortArrayTransfer() param {
      return false;
    }

    proc dsiIteratorYieldsLocalElements() param {
      return false;
    }

    proc isRectangular() param do return false;
    proc isAssociative() param do return false;
    proc isSparse()      param do return false;

    proc type isDefaultRectangular() param do return false;
    proc isDefaultRectangular() param do return false;

    proc isSliceDomainView() param do return false; // likely unnecessary?
    proc isRankChangeDomainView() param do return false;
    proc isReindexDomainView() param do return false;

    // proc dsiAssignDomain is a required overload to implement domain
    // assignment. It is not declared here because we do not wish
    // to use virtual dispatch to versions for all domain arguments.
    //
    // It should be declared like so:
    //     proc dsiAssignDomain(rhs: domain, lhsPrivate:bool)
    //
    // if lhsPrivate=true, the receiver is a private variable
    // that:
    //  hasn't yet been shared with other tasks
    //  doesn't yet have any arrays declared over it
    //
    // Note that assigning to a domain typically causes arrays
    // declared over that domain to be reallocated.
    //
    // Rectangular domains can implement this function with:
    //   proc dsiAssignDomain(rhs: domain, lhsPrivate:bool) {
    //     chpl_assignDomainWithGetSetIndices(this, rhs);
    //   }
    //
    // Irregular domains can implement this function with:
    //   proc dsiAssignDomain(rhs: domain, lhsPrivate:bool) {
    //     chpl_assignDomainWithIndsIterSafeForRemoving(this, rhs);
    //   }
  }

  class BaseRectangularDom : BaseDom {
    param rank : int;
    type idxType;
    param strides: strideKind;

    @chpldoc.nodoc proc hasUnitStride() param do return strides.isOne();
    @chpldoc.nodoc proc hasPosNegUnitStride() param do return strides.isPosNegOne();

    override proc isRectangular() param do return true;

    proc getBaseArrType() type {
      var tmp = new unmanaged BaseArrOverRectangularDom(rank=rank, idxType=idxType, strides=strides);
      return tmp.type;
    }

    proc deinit() {
      // this is a bug workaround
    }

    proc dsiAdd(in x) {
      compilerError("Cannot add indices to a rectangular domain");
    }

    proc dsiRemove(x) {
      compilerError("Cannot remove indices from a rectangular domain");
    }
  }

  class BaseSparseDomImpl : BaseSparseDom(?) {

    var nnzDom = {1..0};

    proc deinit() {
      // this is a bug workaround
    }

    override proc dsiBulkAdd(inds: [] index(rank, idxType),
        dataSorted=false, isUnique=false, addOn=nilLocale){

      var inds_ = inds;
      return bulkAdd_help(inds_, dataSorted, isUnique, addOn);
    }

    override proc dsiBulkAddNoPreserveInds(ref inds: [] index(rank, idxType),
        dataSorted=false, isUnique=false, addOn=nilLocale){

      return bulkAdd_help(inds, dataSorted, isUnique, addOn);
    }

    proc bulkAdd_help(ref inds: [?indsDom] index(rank, idxType),
        dataSorted=false, isUnique=false, addOn=nilLocale): int {
      halt("Helper function called on the BaseSparseDomImpl");
    }

    // TODO: Would ChapelArray.resizeAllocRange() be too expensive?
    //       - would have to put the conditional outside of the call
    /* Grow domain if necessary */
    inline proc _grow(size: int, factor=arrayAsVecGrowthFactor) {
      const oldNNZDomSize = nnzDom.size;
      if (size > oldNNZDomSize) {
        const _newNNZDomSize = if (oldNNZDomSize) then ceil(factor*oldNNZDomSize):int else 1;
        nnzDom = {0..#_newNNZDomSize};
      }
    }

    // TODO: Would ChapelArray.resizeAllocRange() be too expensive?
    //       - would have to put the conditional outside of the call
    /* Shrink domain if necessary */
    inline proc _shrink(size: int, factor=arrayAsVecGrowthFactor) {
      if size == 0 {
        nnzDom = {1..0};
      } else {
        // TODO: floor() ?
        const shrinkThreshold = (nnzDom.size / (factor**2)): int;
        if (size < shrinkThreshold) {
          const _newNNZDomSize = (nnzDom.size / factor): int;
          nnzDom = {0..#_newNNZDomSize};
        }
      }
    }

    /* make the domain "just the right size" */
    inline proc _fit(size: int) {
      nnzDom = {0..<size};
    }

    // This method assumes nnz is updated according to the size
    // requested. So, a bulk addition into a sparse domain should: (1)
    // calculate new nnz and update it, (2) call this method, (3) add
    // indices
    inline proc _bulkGrow() {
      use Math;

      const nnz  = getNNZ();
      if (nnz > nnzDom.size) {
        const _newNNZDomSize = (exp2(log2(nnz)+1.0)):int;

        nnzDom = {0..#_newNNZDomSize};
      }
    }

    inline proc _countDuplicates(arr) where isArray(arr) {
      var dupCount = -1;
      var prev = arr[arr.domain.lowBound];
      for a in arr {
        if a == prev then
          dupCount += 1;
        else
          prev = a;;
      }
      return dupCount;
    }

    // (1) sorts indices if !dataSorted
    // (2) verifies the flags are set correctly if boundsChecking
    // (3) checks OOB if boundsChecking
    proc bulkAdd_prepareInds(ref inds, dataSorted, isUnique, cmp) {
      use Sort;
      if !dataSorted then sort(inds, comparator=cmp);

      //verify sorted and no duplicates if not --fast
      if boundsChecking {
        if dataSorted && !isSorted(inds, comparator=cmp) then
          halt("bulkAdd: Data not sorted, call the function with \
              dataSorted=false");

        //check duplicates assuming sorted
        if isUnique {
          const indsStart = inds.domain.lowBound;
          const indsEnd = inds.domain.highBound;
          var lastInd = inds[indsStart];
          for i in indsStart+1..indsEnd {
            if inds[i] == lastInd then
              halt("bulkAdd: There are duplicates, call the function \
                  with isUnique=false");
            else lastInd = inds[i];
          }
        }

        //check OOB
        for i in inds do boundsCheck(i);
      }
    }

    // this is a helper function for bulkAdd functions in sparse subdomains, which
    // store the nonzeros in order based on their major and minor index
    // NOTE:it assumes that nnz array of the sparse domain has non-negative
    // indices. If, for some reason it changes, this function and bulkAdds have to
    // be refactored. (I think it is a safe assumption at this point and keeps the
    // function a bit cleaner than some other approach. -Engin)
    proc __getActualInsertPts(d, inds, isUnique) {

      //find individual insert points
      //and eliminate duplicates between inds and dom
      var indivInsertPts: [inds.domain] int;
      var actualInsertPts: [inds.domain] int; //where to put in newdom

      //eliminate duplicates --assumes sorted
      if !isUnique {
        //make sure lastInd != inds[inds.domain.lowBound]
        var lastInd = inds[inds.domain.lowBound] + 1;
        for (i, p) in zip(inds, indivInsertPts)  {
          if i == lastInd then p = -1;
          else lastInd = i;
        }
      }

      forall (i,p) in zip(inds, indivInsertPts) {
        if isUnique || p != -1 { //don't do anything if it's duplicate
          const (found, insertPt) = d.find(i);
          p = if found then -1 else insertPt; //mark as duplicate
        }
      }

      //shift insert points for bulk addition
      //previous indexes that are added will cause a shift in the next indexes
      var actualAddCnt = 0;

      //NOTE: this can also be done with scan
      for (ip, ap) in zip(indivInsertPts, actualInsertPts) {
        if ip != -1 {
          ap = ip + actualAddCnt;
          actualAddCnt += 1;
        }
        else ap = ip;
      }

      return (actualInsertPts, actualAddCnt);
    }

    proc dsiClear(){
      halt("not implemented");
    }

  }

  record SparseIndexBuffer {
    param rank: int;
    var obj: borrowed BaseSparseDom(?);

    type idxType = if rank==1 then int else rank*int;
    var bufDom = domain(1);
    var buf: [bufDom] idxType;
    var cur = 0;

    proc init(size, param rank: int, obj) {
      this.rank = rank;
      this.obj = obj;
      bufDom = {0..#size};
    }

    proc ref deinit() {
      commit();
    }

    proc ref add(idx: idxType) {
      buf[cur] = idx;
      cur += 1;

      if cur == buf.size then
        commit();
    }

    proc ref commit() {
      if cur >= 1 then
        obj.dsiBulkAddNoPreserveInds(buf[..cur-1]);
      cur = 0;
    }
  }

  class BaseSparseDom : BaseDom {
    // rank and idxType will be moved to BaseDom
    param rank: int;
    type idxType;
    var parentDom;

    // We currently cannot have dist here. It is due to a compiler bug due to
    // inheritance of generic var fields.
    // var dist;

    /*var nnz = 0; //: int;*/

    override proc isSparse() param do return true;

    proc getNNZ(): int {
      halt("nnz queried on base class");
    }

    proc deinit() {
      // this is a bug workaround
    }

    proc dsiClear() {
      halt("clear not implemented for this distribution - BaseSparseDom");
    }

    proc dsiBulkAdd(inds: [] index(rank, idxType),
        dataSorted=false, isUnique=false,
        addOn=nilLocale): int {

      halt("Bulk addition is not supported by this sparse domain");
    }

    proc dsiBulkAddNoPreserveInds(ref inds: [] index(rank, idxType),
        dataSorted=false, isUnique=false,
        addOn=nilLocale): int {

      halt("Bulk addition is not supported by this sparse domain");
    }

    proc boundsCheck(ind: index(rank, idxType)):void {
      if boundsChecking then
        if !(parentDom.contains(ind)) then
          halt("Sparse domain/array index out of bounds: ", ind,
              " (expected to be within ", parentDom, ")");
    }

    proc canDoDirectAssignment(rhs: domain) {
      if this.parentDom.isRectangular() &&
         rhs.parentDom.isRectangular() {
        if this.dsiNumIndices == 0 {
          if this.parentDom.contains(rhs.parentDom) {
            return true;
          }
        }
      }
      return false;
    }

    //basic DSI functions
    proc dsiDim(d: int) { return parentDom.dim(d); }
    proc dsiDims() { return parentDom.dims(); }
    proc dsiNumIndices { return getNNZ(); }
    proc dsiSize { return getNNZ(); }
    override proc dsiLow { return parentDom.lowBound; }
    override proc dsiHigh { return parentDom.highBound; }
    override proc dsiStride { return parentDom.stride; }
    override proc dsiAlignment { return parentDom.alignment; }
    override proc dsiFirst: rank*idxType {
      halt("dsiFirst is not implemented");
    }
    override proc dsiLast: rank*idxType {
      halt("dsiLast not implemented");
    }
    override proc dsiAlignedLow { return parentDom.low; }
    override proc dsiAlignedHigh { return parentDom.high; }

    override proc dsiCreateIndexBuffer(size) {
      return new SparseIndexBuffer(rank=this.rank, obj=this, size=size);
    }

  } // end BaseSparseDom


  class BaseAssociativeDom : BaseDom {
    override proc isAssociative() param do return true;

    proc deinit() {
      // this is a bug workaround
    }

    proc dsiClear() {
      halt("clear not implemented for this domain");
    }

    proc dsiAdd(in idx) {
      compilerError("Index addition is not supported by this domain");
    }

    proc rank param {
      return 1;
    }
  }

  //
  // Abstract array class
  //
  pragma "base array"
  class BaseArr {
    var prev: unmanaged BaseArr?;
    var next: unmanaged BaseArr?;

    var pid: int = nullPid; // privatized ID, if privatization is supported
    var _decEltRefCounts : bool = false;
    var _resizePolicy = chpl_ddataResizePolicy.normalInit;

    proc chpl__rvfMe() param {
      return false;
    }

    proc isSliceArrayView() param {
      return false;
    }

    proc isRankChangeArrayView() param {
      return false;
    }

    proc isReindexArrayView() param {
      return false;
    }

    proc deinit() {
    }

    proc dsiStaticFastFollowCheck(type leadType) param do return false;

    proc dsiGetBaseDom(): unmanaged BaseDom {
      halt("internal error: dsiGetBaseDom is not implemented");
    }

    // takes 'rmFromList' which indicates whether the array should
    // be removed from the domain's list or just decremented from
    // its count of other arrays.
    //
    // returns (arr, dom)
    // arr is this if it should be deleted, or nil.
    // dom is a domain that should be removed, or nil.
    pragma "dont disable remote value forwarding"
    proc remove(param rmFromList: bool) {
      var ret_arr = this; // this array is always deleted
      var ret_dom:unmanaged BaseDom? = nil;
      var rm_dom = false;

      var dom = dsiGetBaseDom();
      // Remove the array from the domain
      // and find out if the domain should be removed.
      rm_dom = dom.remove_arr(_to_unmanaged(this), rmFromList);

      if rm_dom then
        ret_dom = dom;

      return (ret_arr, ret_dom);
    }

    proc chpl_setResizePolicy(policy: chpl_ddataResizePolicy) {
      _resizePolicy = policy;
    }

    proc chpl_isElementTypeDefaultInitializable(): bool {
      halt("chpl_isElementTypeDefaultInitializable must be defined");
    }

    proc chpl_isElementTypeNonNilableClass(): bool {
      halt("chpl_isElementTypeNonNilableClass must be defined");
    }

    proc chpl_unsafeAssignIsClassElementNil(manager, idx): bool {
      halt("chpl_unsafeAssignIsClassElementNil must be defined");
    }

    proc chpl_unsafeAssignHaltUninitializedElement(idx) {
      halt("chpl_haltUnsafeAssignmentUninitializedElement must be defined");
    }

    proc dsiElementInitializationComplete() {
      halt("dsiElementInitializationComplete must be defined");
    }

    proc dsiElementDeinitializationComplete() {
      halt("dsiElementDeinitializationComplete must be defined");
    }

    proc dsiDestroyArr(deinitElts:bool) {
      halt("dsiDestroyArr must be defined");
    }

    proc dsiReallocate(d: domain) {
      halt("reallocating not supported for this array type");
    }

    proc dsiPostReallocate() {
    }

    // This method is unsatisfactory -- see bradc's commit entries of
    // 01/02/08 around 14:30 for details
    proc _purge( ind: int) {
      halt("purging not supported for this array type");
    }

    proc _resize( length: int, old_map) {
      halt("resizing not supported for this array type");
    }

    //
    // Ultimately, these routines should not appear here; instead, we'd
    // like to do a dynamic cast in the sparse array class(es) that call
    // these routines in order to call them directly and avoid the
    // dynamic dispatch and leaking of this name to the class.  In order
    // to do this we'd need to hoist eltType to the base class, which
    // would require better subclassing of generic classes.  A good
    // summer project for Jonathan?
    //
    proc sparseShiftArray(shiftrange, initrange) {
      halt("sparseGrowDomain not supported for non-sparse arrays");
    }

    proc sparseShiftArrayBack(shiftrange) {
      halt("sparseShiftArrayBack not supported for non-sparse arrays");
    }

    proc sparseBulkShiftArray(shiftMap, oldnnz) {
      halt("sparseBulkShiftArray not supported for non-sparse arrays");
    }


    // methods for associative arrays
    // These are here because the _arrs field is generic over array
    // (and in particular eltType). So we can't cast the elements of _arr
    // to DefaultAssociativeArr (because we don't know the element type).
    proc _defaultInitSlot(slot: int) {
      halt("_defaultInitSlot() not supported for non-associative arrays");
    }
    proc _deinitSlot(slot: int) {
      halt("_deinitSlot() not supported for non-associative arrays");
    }

    proc _startRehash(newSize: int) {
      halt("_startRehash() not supported for non-associative arrays");
    }

    proc _finishRehash(oldSize: int) {
      halt("_finishRehash() not supported for non-associative arrays");
    }

    proc _moveElementDuringRehash(oldslot: int, newslot: int) {
      halt("_moveElementDuringRehash() not supported for non-associative arrays");
    }

    proc dsiDisplayRepresentation() {
      writeln("<no way to display representation>");
    }

    proc dsiSupportsAlignedFollower() param do return false;

    proc dsiSupportsPrivatization() param do return false;
    proc dsiRequiresPrivatization() param do return false;

    proc type isDefaultRectangular() param do return false;
    proc isDefaultRectangular() param do return false;

    proc doiCanBulkTransferRankChange() param do return false;

    proc decEltCountsIfNeeded() {
      // degenerate so it can be overridden
    }

    proc dsiIteratorYieldsLocalElements() param {
      return false;
    }
  }

  /* This subclass is created to allow eltType to be defined in one place
     instead of every subclass of BaseArr.  It can't be put on BaseArr due to
     BaseDom relying on BaseArr not being generic (it creates a list of BaseArrs
     that it refers to and lists can't contain multiple instantiations of a
     generic).
   */
  pragma "base array"
  class AbsBaseArr: BaseArr {
    type eltType;

    override proc decEltCountsIfNeeded() {
      if _decEltRefCounts {
        // unlink domain referred to by eltType
        chpl_decRefCountsForDomainsInArrayEltTypes(_to_unmanaged(this), eltType);
      }
    }
  }

  /* BaseArrOverRectangularDom has this signature so that dsiReallocate
     can be overridden with the right tuple size.

     Note that eltType is not included here. eltType could be included
     in a base class, but here we're looking for a way to narrow
     overloaded functions to only those working with a particular
     kind of bounding box. So if eltType is included, we should make
     another base class.
   */
  pragma "base array"
  class BaseArrOverRectangularDom: BaseArr {
    param rank : int;
    type idxType;
    param strides: strideKind;

    @chpldoc.nodoc proc hasUnitStride() param do return strides.isOne();
    @chpldoc.nodoc proc hasPosNegUnitStride() param do return strides.isPosNegOne();

    // the dsiReallocate to overload only uses the argument with
    // the matching tuple of ranges.

    // Q. Should this pass in a BaseRectangularDom or ranges?
    proc dsiReallocate(bounds: rank*range(idxType,boundKind.both,strides)) {
      halt("reallocating not supported for this array type");
    }

    override proc dsiPostReallocate() {
    }

    proc deinit() {
      // this is a bug workaround
    }
  }

  pragma "base array"
  class BaseRectangularArr: BaseArrOverRectangularDom(?) {
    /* rank, idxType, strides are from BaseArrOverRectangularDom */
    type eltType;

    proc deinit() {
      // this is a bug workaround
    }

    override proc chpl_isElementTypeDefaultInitializable(): bool {
      return isDefaultInitializable(eltType);
    }

    override proc chpl_isElementTypeNonNilableClass(): bool {
      return isNonNilableClass(eltType);
    }

    // TODO: Consult 'chpl_do_fix_thrown_error' for help pinning location.
    override proc chpl_unsafeAssignHaltUninitializedElement(idx) {
      var msg = 'Upon finishing unsafe assignment, one or more elements ' +
                'of a non-default-initializable array of type \'' +
                eltType:string + '\' remain uninitialized';
      halt(msg);
    }

    override proc decEltCountsIfNeeded() {
      if _decEltRefCounts {
        // unlink domain referred to by eltType
        chpl_decRefCountsForDomainsInArrayEltTypes(_to_unmanaged(this), eltType);
      }
    }
  }

  /*
   * BaseSparseArr is very basic/generic so that we have some flexibility in
   * implementing sparse array classes.
   */
  pragma "base array"
  class BaseSparseArr: AbsBaseArr(?) {
    param rank : int;
    type idxType;

    var dom; /* : DefaultSparseDom(?); */

    override proc dsiGetBaseDom() do return dom;

    proc deinit() {
      // this is a bug workaround
    }
  }

  /*
   * All the common helpers/methods in implementations of internal sparse arrays
   * go here.
   */
  pragma "base array"
  class BaseSparseArrImpl: BaseSparseArr(?) {

    pragma "local field" pragma "unsafe"
    // may be initialized separately
    // always destroyed explicitly (to control deiniting elts)
    var data: [dom.nnzDom] eltType;

    proc init(type eltType,
              param rank : int,
              type idxType,
              dom,
              param initElts:bool) {
      super.init(eltType=eltType, rank=rank, idxType=idxType, dom=dom);

      this.data = this.dom.nnzDom.buildArray(eltType, initElts=initElts);
    }

    proc deinit() {
      // Elements in data are deinited in dsiDestroyArr if necessary.
    }

    override proc dsiElementInitializationComplete() {
      data.dsiElementInitializationComplete();
    }

    override proc dsiElementDeinitializationComplete() {
      data.dsiElementDeinitializationComplete();
    }

    override proc dsiDestroyArr(deinitElts:bool) {
      if deinitElts then
        _deinitElements(data);
    }

    // currently there is no support implemented for setting IRV for
    // SparseBlockArr, therefore I moved IRV related stuff to this class, and
    // have SparseBlockArr be a child class of BaseSparseArr directly instead
    // of this one
    var irv: eltType;
    proc IRV ref {
      return irv;
    }

    // shifts data array according to shiftMap where shiftMap[i] is the new index
    // of the ith element of the array. Called at the end of bulkAdd to move the
    // existing items in data array and initialize new indices with irv.
    // oldnnz is the number of elements in the array. As the function is called
    // at the end of bulkAdd, it is almost certain that oldnnz!=data.size
    override proc sparseBulkShiftArray(shiftMap, oldnnz){
      var newIdx: int;
      var prevNewIdx = 0;

      // fill all new indices i s.t. i > indices[oldnnz]
      forall i in shiftMap.domain.highBound+1..dom.nnzDom.highBound do data[i] = irv;

      for (i, _newIdx) in zip(0..#oldnnz by -1, shiftMap.domain.dim(0) by -1) {
        newIdx = shiftMap[_newIdx];
        data[newIdx] = data[i];

        //fill IRV up to previously added nnz
        for emptyIndex in newIdx+1..prevNewIdx-1 do data[emptyIndex] = irv;
        prevNewIdx = newIdx;
      }
      //fill the initial added space with IRV
      for i in 0..prevNewIdx-1 do data[i] = irv;
    }

    // shift data array after single index addition. Fills the new index with irv
    override proc sparseShiftArray(shiftrange, initrange) {
      for i in initrange {
        data(i) = irv;
      }
      for i in shiftrange by -1 {
        data(i+1) = data(i);
      }
      data(shiftrange.lowBound) = irv;
    }

    override proc sparseShiftArrayBack(shiftrange) {
      for i in shiftrange {
        data(i) = data(i+1);
      }
    }
  }

  // delete helpers

  // param privatized here is a workaround for the fact that
  // we can't include the privatized freeing for DefaultRectangular
  // because of resolution order issues
  proc _delete_dist(dist:unmanaged BaseDist, privatized:bool) {
    dist.dsiDestroyDist();

    if _privatization && privatized {
      _freePrivatizedClass(dist.pid, dist);
    }

    delete dist;
  }

  proc _delete_dom(dom, privatized:bool) {

    dom.dsiDestroyDom();

    if _privatization && privatized {
      _freePrivatizedClass(dom.pid, dom);
    }

    delete dom;
  }

  proc _delete_arr(arr: unmanaged BaseArr, param privatized:bool,
                   deinitElts=true) {
    // array implementation can destroy data or other members
    arr.dsiDestroyArr(deinitElts=deinitElts);

    // not necessary for aliases/slices because the original
    // array will take care of it.
    // This needs to be done after the array elements are destroyed
    // (by dsiDestroyArray above) because the array elements might
    // refer to this inner domain.
    arr.decEltCountsIfNeeded();

    if _privatization && privatized {
      _freePrivatizedClass(arr.pid, arr);
    }

    // runs the array destructor
    delete arr;
  }

  // domain assignment helpers

  private proc castIndices(from, lhs) {
    param rank = lhs.rank;
    compilerAssert(rank == from.size);

    type resultType = range(lhs.idxType, boundKind.both, lhs.strides);
    if from(0).type == resultType then
      return from;

    var result: rank * resultType;
    for param i in 0..rank-1 do
      result(i) = from(i) : resultType;

    return result;
  }

  // Implement simple reallocate/set indices/post reallocate
  // for compatibility.
  // Domain implementations may supply their own dsiAssignDomain
  // that does something else.
  // lhs is a subclass of BaseRectangularDom
  proc chpl_assignDomainWithGetSetIndices(lhs:?t, rhs: domain)
    where isSubtype(_to_borrowed(t),BaseRectangularDom)
  {
    const rhsInds = rhs.getIndices();
    type arrType = lhs.getBaseArrType();

    for e in lhs._arrs do {
      on e {
        if const eCast = e:arrType? then
          eCast.dsiReallocate(castIndices(rhsInds, lhs));
          // castIndices() is not hoisted because 'lhs' may not have any arrays
        else
          halt("internal error: ", t:string,
               " contains a bad array type ", arrType:string);
      }
    }

    // todo: should we cast indices for dsiSetIndices like for dsiReallocate?
    lhs.dsiSetIndices(rhsInds);

    for e in lhs._arrs do {
      var eCastQ = e:arrType?;
      var eCast = eCastQ!;
      on e do eCast.dsiPostReallocate();
    }

    if lhs.dsiSupportsPrivatization() {
      _reprivatize(lhs);
    }
  }


  proc chpl_assignDomainWithIndsIterSafeForRemoving(lhs:?t, rhs: domain)
    where isSubtype(_to_borrowed(t),BaseSparseDom) ||
          isSubtype(_to_borrowed(t),BaseAssociativeDom)
  {
    //
    // BLC: It's tempting to do a clear + add here, but because
    // we need to preserve array values that are in the intersection
    // between the old and new index sets, we use the following
    // instead.
    //
    // A domain implementation is free to write their own
    // dsiAssignDomain instead of using this method.

    for i in lhs.dsiIndsIterSafeForRemoving() {
      if !rhs.contains(i) {
        lhs.dsiRemove(i);
      }
    }
    for i in rhs {
      if !lhs.dsiMember(i) {
        lhs.dsiAdd(i);
      }
    }
  }
}
