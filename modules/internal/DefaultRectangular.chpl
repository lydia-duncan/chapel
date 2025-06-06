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

// DefaultRectangular.chpl
//
module DefaultRectangular {
  import HaltWrappers;
  @unstable("The variable 'dataParTasksPerLocale' is unstable and its interface is subject to change in the future")
  config const dataParTasksPerLocale = 0;
  @unstable("The variable 'dataParIgnoreRunningTasks' is unstable and its interface is subject to change in the future")
  config const dataParIgnoreRunningTasks = false;
  @unstable("The variable 'dataParMinGranularity' is unstable and its interface is subject to change in the future")
  config const dataParMinGranularity: int = 1;

  if dataParTasksPerLocale<0 then halt("dataParTasksPerLocale must be >= 0");
  if dataParMinGranularity<=0 then halt("dataParMinGranularity must be > 0");

  use DSIUtil;
  use ChapelArray;
  use ChapelDistribution, ChapelRange, OS, CTypes, CTypes;
  use ChapelDebugPrint, ChapelLocks, OwnedObject, IO;
  use DefaultSparse, DefaultAssociative;
  public use ExternalArray; // OK: currently expected to be available by
                            // default... though... why 'use' it here?

  config param debugDefaultDist = false;
  config param debugDefaultDistBulkTransfer = false;
  config param debugDataPar = false;
  config param debugDataParNuma = false;
  config param disableArrRealloc = false;
  config param reportInPlaceRealloc = false;

  config param parallelAssignThreshold = 2*1024*1024;
  config param enableParallelGetsInAssignment = false;
  config param enableParallelPutsInAssignment = false;

  config param defaultDoRADOpt = true;
  config param defaultDisableLazyRADOpt = false;
  config param earlyShiftData = true;
  config param usePollyArrayIndex = false;

  config param defaultRectangularSupportsAutoLocalAccess = false;

  enum ArrayStorageOrder { RMO, CMO }
  config param defaultStorageOrder = ArrayStorageOrder.RMO;
  // would like to move this into DefaultRectangularArr and
  // DefaultRectangularDom so each instance can choose individually
  param storageOrder = defaultStorageOrder;

  // A function which help to compute the final index
  // to be used for DefaultRectangularArr access. This function
  // helps Polly to effectively communicate the array dimension
  // sizes and the index subscripts to Polly.
  pragma "lineno ok"
  pragma "llvm readnone"
  proc polly_array_index(arguments:int ...):int {
    param rank = (arguments.size - 1) / 2;
    param blkStart = 2;
    param blkEnd = 2 + rank - 1;
    param indStart = blkEnd + 1;
    param indEnd = indStart + rank - 1;
    var offset = arguments(0);
    var blk:rank*int;
    var ind:rank*int;

    blk(rank-1) = 1;
    for param i in 0..(rank-2) by -1 do
      blk(i) = blk(i+1) * arguments(blkStart+i);

    for param j in 0..rank-1 {
      ind(j) = arguments(indStart+j-1);
    }

    var ret:int = offset;
    for param i in 0..rank-1 {
      ret += ind(i) * blk(i);
    }

    return ret;
  }

  @unstable("DefaultDist is unstable and may change in the future")
  class DefaultDist: BaseDist {
    override proc dsiNewRectangularDom(param rank: int, type idxType,
                                       param strides: strideKind, inds) {
      const dom = new unmanaged DefaultRectangularDom(rank, idxType, strides,
                                                      _to_unmanaged(this));
      dom.dsiSetIndices(inds);
      return dom;
    }

    override proc dsiNewAssociativeDom(type idxType, param parSafe: bool) do
      return new unmanaged DefaultAssociativeDom(idxType, parSafe, _to_unmanaged(this));

    override proc dsiNewSparseDom(param rank: int, type idxType, dom: domain) do
      return new unmanaged DefaultSparseDom(rank, idxType, _to_unmanaged(this), dom);

    proc dsiTargetLocales() const ref do
      return chpl_getSingletonLocaleArray(this.locale);

    proc dsiIndexToLocale(ind) do return this.locale;

    // Right now, the default distribution acts like a singleton.
    // So we don't have to copy it when a clone is requested.
    proc dsiClone() do return _to_unmanaged(this);

    proc dsiAssign(other: this.type) { }

    proc dsiEqualDMaps(d:unmanaged DefaultDist) param do return true;
    proc dsiEqualDMaps(d) param do return false;

    override proc trackDomains() param do return false;
    override proc dsiTrackDomains() do    return false;

    override proc singleton() param do return true;

    override proc dsiIsLayout() param do return true;
  }

  //
  // Replicated copies are set up in chpl_initOnLocales() during locale
  // model initialization
  //
  pragma "locale private"
  var defaultDist = new dmap(new unmanaged DefaultDist());

  proc chpl_defaultDistInitPrivate() {
    if defaultDist._value==nil {
      defaultDist = new dmap(new DefaultDist());
    }
  }

  class DefaultRectangularDom: BaseRectangularDom(?) {
    var dist: unmanaged DefaultDist;
    var ranges : rank*range(idxType,boundKind.both,strides);

    override proc linksDistribution() param do return false;
    override proc dsiLinksDistribution() do     return false;

    override proc type isDefaultRectangular() param do return true;
    override proc isDefaultRectangular() param do return true;

    proc init(param rank, type idxType, param strides, dist) {
      super.init(rank, idxType, strides);
      this.dist = dist;
    }

    proc chpl_integralIdxType type {
      return chpl__idxTypeToIntIdxType(idxType);
    }

    override proc dsiMyDist() {
      return dist;
    }

    @chpldoc.nodoc
    record _serialized_domain {
      param rank;
      type idxType;
      param strides;
      var dims;
      param isDefaultRectangular;
    }

    proc chpl__serialize() {
      return new _serialized_domain(rank, idxType, strides, dsiDims(), true);
    }

    proc type chpl__deserialize(data) {
      return defaultDist.newRectangularDom(data.rank,
                                           data.idxType,
                                           data.strides,
                                           data.dims);

    }

    override proc dsiDisplayRepresentation() {
      writeln("ranges = ", ranges);
    }

    // function and iterator versions, also for setIndices
    proc dsiGetIndices() do return ranges;

    proc dsiSetIndices(x) {
      ranges = x;
    }

    proc dsiAssignDomain(rhs: domain, lhsPrivate:bool) {
      chpl_assignDomainWithGetSetIndices(this, rhs);
    }

    iter these_help(param d: int) /*where storageOrder == ArrayStorageOrder.RMO*/ {
      if d == rank-1 {
        foreach i in ranges(d) do
          yield i;
      } else if d == rank - 2 {
        foreach i in ranges(d) do
          foreach j in these_help(rank-1) do
            yield (i, j);
      } else {
        foreach i in ranges(d) do
          foreach j in these_help(d+1) do
            yield (i, (...j));
      }
    }
/*
    iter these_help(param d: int) where storageOrder == ArrayStorageOrder.CMO {
      param rd = rank - d + 1;
      if rd == 1 {
        for i in ranges(rd) do
          yield i;
      } else if rd == 2 {
        for i in ranges(rd) do
          for j in these_help(rank-1) do
            yield (j, i);
      } else {
        for i in ranges(rd) do
          for j in these_help(d+1) do
            yield ((...j), i);
      }
    }
*/

    iter these_help(param d: int, block) /*where storageOrder == ArrayStorageOrder.RMO*/ {
      if d == block.size-1 {
        foreach i in block(d) do
          yield i;
      } else if d == block.size - 2 {
        foreach i in block(d) do
          foreach j in these_help(block.size-1, block) do
            yield (i, j);
      } else {
        foreach i in block(d) do
          foreach j in these_help(d+1, block) do
            yield (i, (...j));
      }
    }

/*
    iter these_help(param d: int, block) where storageOrder == ArrayStorageOrder.CMO {
      param rd = rank - d + 1;
      if rd == 1 {
        for i in block(rd) do
          yield i;
      } else if rd == 2 {
        for i in block(rd) do
          for j in these_help(block.size, block) do
            yield (j, i);
      } else {
        for i in block(rd) do
          for j in these_help(d+1, block) do
            yield ((...j), i);
      }
    }
*/

    iter these(tasksPerLocale = dataParTasksPerLocale,
               ignoreRunning = dataParIgnoreRunningTasks,
               minIndicesPerTask = dataParMinGranularity,
               offset=createTuple(rank, chpl_integralIdxType, 0:chpl_integralIdxType)) {
      if rank == 1 {
        for i in ranges(0) do
          yield i;
      } else {
        for i in these_help(0) do
          yield i;
      }
    }

    iter these(param tag: iterKind,
               tasksPerLocale = dataParTasksPerLocale,
               ignoreRunning = dataParIgnoreRunningTasks,
               minIndicesPerTask = dataParMinGranularity,
               offset=createTuple(rank, chpl_integralIdxType, 0:chpl_integralIdxType))
      where tag == iterKind.standalone {
      if chpl__testParFlag then
        chpl__testPar("default rectangular domain standalone invoked on ", ranges);
      if debugDefaultDist then
        chpl_debug_writeln("*** In domain standalone code:");

      const numTasks = if tasksPerLocale == 0 then here.maxTaskPar
                       else tasksPerLocale;
      if debugDefaultDist {
        chpl_debug_writeln("    numTasks=", numTasks, " (", ignoreRunning,
                "), minIndicesPerTask=", minIndicesPerTask);
      }
      const (numChunks, parDim) = if __primitive("task_get_serial") then
                                  (1, 0) else
                                  _computeChunkStuff(numTasks,
                                                     ignoreRunning,
                                                     minIndicesPerTask,
                                                     ranges);
      if debugDefaultDist {
        chpl_debug_writeln("    numChunks=", numChunks, " parDim=", parDim,
                           " ranges(", parDim, ").size=", ranges(parDim).sizeAs(uint));
      }
      if debugDataPar {
        chpl_debug_writeln("### numTasksPerLoc = ", numTasks, "\n",
                           "### ignoreRunning = ", ignoreRunning, "\n",
                           "### minIndicesPerTask = ", minIndicesPerTask, "\n",
                           "### numChunks = ", numChunks, " (parDim = ", parDim, ")\n",
                           "### nranges = ", ranges);
      }
      if debugDefaultDist {
        chpl_debug_writeln("*** DI: ranges = ", ranges);
      }
      // TODO: The following is somewhat of an abuse of what
      // _computeBlock() was designed for (dense ranges only; I
      // multiplied by the stride as a white lie to make it work
      // reasonably.  We should switch to using the RangeChunk
      // library...
      coforall chunk in 0..#numChunks {
        const ranges = this.ranges;
        const len = ranges(parDim).sizeAs(uint)
                    * abs(ranges(parDim).stride):uint;
        const (lo,hi) = _computeBlock(len,
                                      numChunks, chunk,
                                      ranges(parDim)._high,
                                      ranges(parDim)._low,
                                      ranges(parDim)._low);
        var block = ranges;
        block(parDim)._low = lo;  // preserve stride, alignment
        block(parDim)._high = hi;
        if debugDefaultDist {
          chpl_debug_writeln("*** DI[", chunk, "]: block = ", block);
        }
        for i in these_help(0, block) {
          yield i;
        }
      }
    }

    iter these(param tag: iterKind,
               tasksPerLocale = dataParTasksPerLocale,
               ignoreRunning = dataParIgnoreRunningTasks,
               minIndicesPerTask = dataParMinGranularity,
               offset=createTuple(rank, chpl_integralIdxType, 0:chpl_integralIdxType))
      where tag == iterKind.leader {

      const numSublocs = here._getChildCount();

      if localeModelPartitionsIterationOnSublocales && numSublocs != 0 {
        var dptpl = if tasksPerLocale==0 then here.maxTaskPar
                    else tasksPerLocale;
        if !ignoreRunning {
          const otherTasks = here.runningTasks() - 1; // don't include self
          dptpl = if otherTasks < dptpl then (dptpl-otherTasks):int else 1;
        }
        // Make sure we don't use more sublocales than the numbers of
        // tasksPerLocale requested
        const numSublocTasks = min(numSublocs, dptpl);
        // For serial tasks, we will only have a single chunk
        const (numChunks, parDim) = if __primitive("task_get_serial") then
                                    (1, 0) else
                                    _computeChunkStuff(numSublocTasks,
                                                       ignoreRunning=true,
                                                       minIndicesPerTask,
                                                       ranges);
        if debugDataParNuma {
          chpl_debug_writeln("### numSublocs = ", numSublocs, "\n",
                 "### numTasksPerSubloc = ", numSublocTasks, "\n",
                  "### ignoreRunning = ", ignoreRunning, "\n",
                  "### minIndicesPerTask = ", minIndicesPerTask, "\n",
                  "### numChunks = ", numChunks, " (parDim = ", parDim, ")\n",
                  "### nranges = ", ranges);
        }

        coforall chunk in 0..#numChunks { // make sure coforall on can trigger
          local do on here._getChild(chunk) {
            if debugDataParNuma {
              if chunk!=chpl_getSubloc() then
                chpl_debug_writeln("*** ERROR: ON WRONG SUBLOC (should be ", chunk,
                                   ", on ", chpl_getSubloc(), ") ***");
            }
            // Divide the locale's tasks approximately evenly
            // among the sublocales
            const numSublocTasks = (if chunk < dptpl % numChunks
                                    then dptpl / numChunks + 1
                                    else dptpl / numChunks);
            var locBlock: rank*range(chpl_integralIdxType);
            for param i in 0..rank-1 do
              locBlock(i) = offset(i)..#(ranges(i).sizeAs(chpl_integralIdxType));
            var followMe: rank*range(chpl_integralIdxType) = locBlock;
            const (lo,hi) = _computeBlock(locBlock(parDim).sizeAs(chpl_integralIdxType),
                                          numChunks, chunk,
                                          locBlock(parDim)._high,
                                          locBlock(parDim)._low,
                                          locBlock(parDim)._low);
            followMe(parDim) = lo..hi;
            const (numChunks2, parDim2) = _computeChunkStuff(numSublocTasks,
                                                             ignoreRunning=true,
                                                             minIndicesPerTask,
                                                             followMe);
            coforall chunk2 in 0..#numChunks2 {
              var locBlock2: rank*range(chpl_integralIdxType);
              for param i in 0..rank-1 do
                locBlock2(i) = followMe(i).lowBound..followMe(i).highBound;
              var followMe2: rank*range(chpl_integralIdxType) = locBlock2;
              const low  = locBlock2(parDim2)._low,
                high = locBlock2(parDim2)._high;
              const (lo,hi) = _computeBlock(locBlock2(parDim2).sizeAs(chpl_integralIdxType),
                                            numChunks2, chunk2,
                                            high, low, low);
              followMe2(parDim2) = lo..hi;
              if debugDataParNuma {
                chpl_debug_writeln("### chunk = ", chunk, "  chunk2 = ", chunk2, "  ",
                        "followMe = ", followMe, "  followMe2 = ", followMe2);
              }
              yield followMe2;
            }
          }
        }
      } else {

        if debugDefaultDist then
          chpl_debug_writeln("*** In domain/array leader code:"); // this = ", this);
        const numTasks = if tasksPerLocale==0 then here.maxTaskPar
                         else tasksPerLocale;

        if debugDefaultDist then
          chpl_debug_writeln("    numTasks=", numTasks, " (", ignoreRunning,
                  "), minIndicesPerTask=", minIndicesPerTask);

        const (numChunks, parDim) = if __primitive("task_get_serial") then
                                    (1, 0) else
                                    _computeChunkStuff(numTasks,
                                                       ignoreRunning,
                                                       minIndicesPerTask,
                                                       ranges);
        if debugDefaultDist then
          chpl_debug_writeln("    numChunks=", numChunks, " parDim=", parDim,
                  " ranges(", parDim, ").size=", ranges(parDim).sizeAs(uint));

        if debugDataPar {
          chpl_debug_writeln("### numTasksPerLoc = ", numTasks, "\n",
                 "### ignoreRunning = ", ignoreRunning, "\n",
                 "### minIndicesPerTask = ", minIndicesPerTask, "\n",
                 "### numChunks = ", numChunks, " (parDim = ", parDim, ")\n",
                  "### nranges = ", ranges);
        }

        var locBlock: rank*range(chpl_integralIdxType);
        for param i in 0..rank-1 do
          locBlock(i) = offset(i)..#(ranges(i).sizeAs(chpl_integralIdxType));
        if debugDefaultDist then
          chpl_debug_writeln("*** DI: locBlock = ", locBlock);
        coforall chunk in 0..#numChunks {
          var followMe: rank*range(chpl_integralIdxType) = locBlock;
          const (lo,hi) = _computeBlock(locBlock(parDim).sizeAs(chpl_integralIdxType),
                                        numChunks, chunk,
                                        locBlock(parDim)._high,
                                        locBlock(parDim)._low,
                                        locBlock(parDim)._low);
          followMe(parDim) = lo..hi;
          if debugDefaultDist then
            chpl_debug_writeln("*** DI[", chunk, "]: followMe = ", followMe);
          yield followMe;
        }
      }
    }

    iter these(param tag: iterKind, followThis,
               tasksPerLocale = dataParTasksPerLocale,
               ignoreRunning = dataParIgnoreRunningTasks,
               minIndicesPerTask = dataParMinGranularity,
               offset=createTuple(rank, chpl_integralIdxType, 0:chpl_integralIdxType))
      where tag == iterKind.follower {

      if followThis.size != this.rank then
        compilerError("rank mismatch in zippered iteration (can't zip a " +
                      followThis.size:string + "D expression with a " +
                      this.rank:string + "D domain)");

      if chpl__testParFlag then
        chpl__testPar("default rectangular domain follower invoked on ", followThis);
      if debugDefaultDist then
        chpl_debug_writeln("In domain follower code: Following ", followThis);

      param newStrides = chpl_strideProduct(this.strides,
                                            chpl_strideUnion(followThis));

      var block: rank*range(idxType=chpl_integralIdxType, strides=newStrides);
      if boundsChecking then
        for param i in 0..rank-1 do
          if followThis(i).highBound >= ranges(i).sizeAs(uint) then
            HaltWrappers.boundsCheckHalt("size mismatch in zippered iteration (dimension " + i:string + ")");

      if ! newStrides.isPosNegOne() {
        type strType = chpl__signedType(chpl_integralIdxType);
        for param i in 0..rank-1 {
          const rStride = ranges(i).stride;
          const rSignedStride = rStride:strType,
                fSignedStride = followThis(i).stride:strType;
          if ranges(i).hasPositiveStride() {
            const riStride = rStride:chpl_integralIdxType;
            const low = ranges(i).alignedLowAsInt + followThis(i).lowBound*riStride,
                  high = ranges(i).alignedLowAsInt + followThis(i).highBound*riStride,
                  stride = (rSignedStride * fSignedStride):strType;
            block(i).chpl_setFields(low, high, stride);

          } else {
            const irStride = (-rStride):chpl_integralIdxType;
            const low = ranges(i).alignedHighAsInt - followThis(i).highBound*irStride,
                  high = ranges(i).alignedHighAsInt - followThis(i).lowBound*irStride,
                  stride = (rSignedStride * fSignedStride):strType;
            block(i).chpl_setFields(low, high, stride);
          }
        }
      } else {
        // else-branch duplicates then-branch, except here strides are params
        type strType = chpl__signedType(chpl_integralIdxType);
        for param i in 0..rank-1 {
          param rStride = ranges(i).stride;
          param rSignedStride = rStride:strType,
                fSignedStride = followThis(i).stride:strType;
          if ranges(i).hasPositiveStride() {
            param riStride = rStride:chpl_integralIdxType;
            const low = ranges(i).alignedLowAsInt + followThis(i).lowBound*riStride,
                  high = ranges(i).alignedLowAsInt + followThis(i).highBound*riStride;
            param stride = (rSignedStride * fSignedStride):strType;
            block(i).chpl_setFields(low, high);

          } else {
            param irStride = (-rStride):chpl_integralIdxType;
            const low = ranges(i).alignedHighAsInt - followThis(i).highBound*irStride,
                  high = ranges(i).alignedHighAsInt - followThis(i).lowBound*irStride;
            param stride = (rSignedStride * fSignedStride):strType;
            block(i).chpl_setFields(low, high);
          }
        }
      }

      if rank == 1 {
        foreach i in zip((...block)) {
          yield chpl_intToIdx(i);
        }
      } else {
        foreach i in these_help(0, block) {
          yield chpl_intToIdx(i);
        }
      }
    }

    proc dsiMember(ind: rank*idxType) {
      for param i in 0..rank-1 do
        if !ranges(i).contains(ind(i)) then
          return false;
      return true;
    }

    proc dsiIndexOrder(ind: rank*idxType) {
      var totOrder: int;
      var blk = 1;
      for param d in 0..rank-1 by -1 {
        const orderD = ranges(d).indexOrder(ind(d));
        // NOTE: This follows from the implementation of indexOrder()
        if (orderD == (-1):chpl_integralIdxType) then return orderD;
        totOrder += orderD * blk;
        blk *= ranges(d).sizeAs(int);
      }
      return totOrder;
    }

    proc dsiDims() do
      return ranges;

    proc dsiDim(d : int) do
      return ranges(d);

    // optional, is this necessary? probably not now that
    // homogeneous tuples are implemented as C vectors.
    proc dsiDim(param d : int) do
      return ranges(d);

    proc dsiNumIndices {
      var sum = 1;
      for param i in 0..rank-1 do
        sum *= ranges(i).sizeAs(int);
      return sum;
      // WANT: return * reduce (this(0..rank-1).size);
    }

    proc parSafe param { dnsError("parSafe"); }

    override proc dsiLow {
      if rank == 1 {
        return ranges(0).lowBound;
      } else {
        var result: rank*idxType;
        for param i in 0..rank-1 do
          result(i) = ranges(i).lowBound;
        return result;
      }
    }

    override proc dsiHigh {
      if rank == 1 {
        return ranges(0).highBound;
      } else {
        var result: rank*idxType;
        for param i in 0..rank-1 do
          result(i) = ranges(i).highBound;
        return result;
      }
    }

    override proc dsiAlignedLow {
      if rank == 1 {
        return ranges(0).low;
      } else {
        var result: rank*idxType;
        for param i in 0..rank-1 do
          result(i) = ranges(i).low;
        return result;
      }
    }

    override proc dsiAlignedHigh {
      if rank == 1 {
        return ranges(0).high;
      } else {
        var result: rank*idxType;
        for param i in 0..rank-1 do
          result(i) = ranges(i).high;
        return result;
      }
    }

    override proc dsiStride {
      if rank == 1 {
        return ranges(0).stride;
      } else {
        var result: rank*chpl__signedType(chpl_integralIdxType);
        for param i in 0..rank-1 do
          result(i) = ranges(i).stride;
        return result;
      }
    }

    override proc dsiAlignment {
      if rank == 1 {
        return ranges(0).alignment;
      } else {
        var result: rank*idxType;
        for param i in 0..rank-1 do
          result(i) = ranges(i).alignment;
        return result;
      }
    }

    override proc dsiFirst {
      if rank == 1 {
        return ranges(0).first;
      } else {
        var result: rank*idxType;
        for param i in 0..rank-1 do
          result(i) = ranges(i).first;
        return result;
      }
    }

    override proc dsiLast {
      if rank == 1 {
        return ranges(0).last;
      } else {
        var result: rank*idxType;
        for param i in 0..rank-1 do
          result(i) = ranges(i).last;
        return result;
      }
    }

    proc dsiBuildArray(type eltType, param initElts:bool) {
      return new unmanaged DefaultRectangularArr(eltType=eltType, rank=rank,
                                                 idxType=idxType,
                                                 strides=strides,
                                                 dom=_to_unmanaged(this),
                                                 initElts=initElts);
    }

    proc doiTryCreateArray(type eltType) throws {
      // TODO: Update to support higher dimension (not needed in Arkouda)
      if rank != 1 then
        throw new Error("'tryCreateArray' is only supported on domains of rank 1");

      var data = _try_ddata_allocate(eltType, ranges(0).size);
      return new unmanaged DefaultRectangularArr(eltType=eltType, rank=rank,
                                                 idxType=idxType,
                                                 strides=strides,
                                                 dom=_to_unmanaged(this),
                                                 data=data);
    }

    proc dsiBuildArrayWith(type eltType, data:_ddata(eltType), allocSize:int) {
      return new unmanaged DefaultRectangularArr(eltType=eltType,
                                       rank=rank,
                                       idxType=idxType,
                                       strides=strides,
                                       dom=_to_unmanaged(this),
                                       // consider the elements already inited
                                       initElts=false,
                                       // but the array should deinit them
                                       deinitElts=true,
                                       data=data);
    }

    proc doiBuildArrayMoving(from: DefaultRectangularArr(?)) {
      var movedData = from.data;
      from.data = nil; // so that it won't be freed when 'from' is deleted
      return new unmanaged DefaultRectangularArr(
                                       eltType=from.eltType,
                                       rank=rank,
                                       idxType=idxType,
                                       strides=strides,
                                       // consider the elements already inited
                                       initElts=false,
                                       // but the array should deinit them
                                       deinitElts=true,
                                       dom=_to_unmanaged(this),
                                       data=movedData);
    }

    proc dsiLocalSlice(ranges) {
      halt("all dsiLocalSlice calls on DefaultRectangulars should be handled in ChapelArray.chpl");
    }

    proc dsiTargetLocales() const ref {
      return chpl_getSingletonLocaleArray(this.locale);
    }

    proc dsiHasSingleLocalSubdomain() param do return true;

    proc dsiLocalSubdomain(loc: locale) {
      if (this.locale == loc) {
        return _getDomain(_to_unmanaged(this));
      } else {
        var a: domain(rank, idxType, strides);
        return a;
      }
    }

    iter dsiLocalSubdomains(loc: locale) {
      yield dsiLocalSubdomain(loc);
    }

    // convenience routine for turning an int (tuple) into an index (tuple)
    inline proc chpl_intToIdx(i) {
      return chpl__intToIdx(this.idxType, i);
    }
  }

  // helper routines for converting tuples of integers into tuple indices

  inline proc chpl__intToIdx(type idxType, i: integral, j ...) {
    const first = chpl__intToIdx(idxType, i);
    const rest = chpl__intToIdx(idxType, (...j));
    return (first, (...rest));
  }

  inline proc chpl__intToIdx(type idxType, i: integral, j: integral) {
    return (chpl__intToIdx(idxType, i), chpl__intToIdx(idxType, j));
  }

  inline proc chpl__intToIdx(type idxType, i: _tuple) {
    return chpl__intToIdx(idxType, (...i));
  }

  // TODO: should this include the ranges that represent the domain?
  record _remoteAccessData {
    type eltType;
    param rank : int;
    type idxType;
    param strides: strideKind;
    param blkChanged : bool = false;

    var off: rank*idxType;
    var blk: rank*int;
    var str: rank*chpl__signedType(chpl__idxTypeToIntIdxType(idxType));
    var origin: int;
    var factoredOffs: int;

    var data: _ddata(eltType);
    var shiftedData: _ddata(eltType);

    proc hasUnitStride() param do return strides == strideKind.one;

    inline proc ref theData ref {
      if ! hasUnitStride() {
        return data;
      } else {
        return shiftedData;
      }
    }

    inline proc getDataElem(i) ref {
      if ! hasUnitStride() {
        return dataElem(i);
      } else {
        return shiftedDataElem(i);
      }
    }

    inline proc dataElem(i) ref {
      return data(i);
    }

    inline proc shiftedDataElem(i) ref do
      return shiftedData(i);
  }

  inline proc _remoteAccessData.getDataIndex(ind : idxType) {
    return this.getDataIndex(chpl__tuplify(ind));
  }

  //
  // Copied from DefaultRectangularArr.getDataIndex
  //
  inline proc _remoteAccessData.getDataIndex(ind: rank*idxType) {
    if ! hasUnitStride() {
      var sum = origin;
      for param i in 0..rank-1 do
        sum += (chpl__idxToInt(ind(i)) - chpl__idxToInt(off(i))).safeCast(int) * blk(i) / abs(str(i));
      return sum;
    } else {
      // optimize common case to get cleaner generated code
      if (rank == 1 && earlyShiftData) {
        if blkChanged {
          return chpl__idxToInt(ind(0)):int * blk(0);
        } else {
          return chpl__idxToInt(ind(0)):int;
        }
      } else {
        var sum = if earlyShiftData then 0 else origin;

        if blkChanged {
          for param i in 0..rank-1 {
            sum += chpl__idxToInt(ind(i)):int * blk(i);
          }
        } else {
          if storageOrder == ArrayStorageOrder.RMO {
            for param i in 0..rank-2 {
              sum += chpl__idxToInt(ind(i)):int * blk(i);
            }
            sum += chpl__idxToInt(ind(rank-1)):int;
          } else {
            for param i in 1..rank-1 {
              sum += chpl__idxToInt(ind(i)):int * blk(i);
            }
            sum += chpl__idxToInt(ind(0)):int;
          }
        }

        if !earlyShiftData then sum -= factoredOffs;
        return sum;
      }
    }
  }

  proc ref _remoteAccessData.computeFactoredOffs() {
    factoredOffs = 0;
    for param i in 0..rank-1 do {
      factoredOffs = factoredOffs + blk(i) * chpl__idxToInt(off(i)):int;
    }
  }

  proc ref _remoteAccessData.initShiftedData() {
    if earlyShiftData && hasUnitStride() {
      type idxSignedType = chpl__signedType(chpl__idxTypeToIntIdxType(idxType));
      const shiftDist = if isIntType(idxType) then origin - factoredOffs
                        else origin:idxSignedType - factoredOffs:idxSignedType;
      shiftedData = _ddata_shift(eltType, data, shiftDist);
    }
  }

  proc _remoteAccessData.strideAlignUp(lo, r) do
    return r.lowBound + (lo - r.lowBound + abs(r.stride):idxType - 1)
           / abs(r.stride):idxType * abs(r.stride):idxType;

  proc _remoteAccessData.strideAlignDown(hi, r) do
    return hi - (hi - r.lowBound) % abs(r.stride):idxType;

  proc ref _remoteAccessData.initDataFrom(other : _remoteAccessData) {
    this.data = other.data;
  }

  //
  // Based on the old 'dsiSlice' method
  //
  proc _remoteAccessData.toSlice(newDom) {
    compilerAssert(this.rank == newDom.rank);

    // NB: Sets 'blkChanged' if the new domain is stridable.
    var rad : _remoteAccessData(eltType, newDom.rank, newDom.idxType, newDom.strides, ! newDom.hasUnitStride() || this.blkChanged);

    rad.initDataFrom(this);

    rad.shiftedData = if ! newDom.hasUnitStride() then this.data else this.shiftedData;
    rad.origin      = this.origin;
    rad.off         = chpl__tuplify(newDom.dsiLow);
    rad.str         = chpl__tuplify(newDom.dsiStride);

    for param i in 0..rank-1 {
      const shift = this.blk(i) * (chpl__idxToInt(newDom.dsiDim(i).lowBound) - chpl__idxToInt(this.off(i))).safeCast(int) / abs(this.str(i));
      if this.str(i) > 0 {
        rad.origin += shift;
      } else {
        rad.origin -= shift;
      }

      const mult = (newDom.dsiDim(i).stride / this.str(i));
      rad.blk(i) = this.blk(i) * mult;
    }

    rad.computeFactoredOffs();
    rad.initShiftedData();

    return rad;
  }

  //
  // Based on the old 'dsiReindex' method
  //
  proc _remoteAccessData.toReindex(newDom) {
    compilerAssert(this.rank == newDom.rank);

    // NB: Only sets 'blkChanged' if underlying RADs have it set
    var rad : _remoteAccessData(eltType, newDom.rank, newDom.idxType, newDom.strides, blkChanged);

    rad.initDataFrom(this);

    rad.shiftedData  = if ! newDom.hasUnitStride() then this.data else this.shiftedData;
    rad.origin       = this.origin;
    rad.blk          = this.blk;
    rad.off          = chpl__tuplify(newDom.dsiLow);
    rad.str          = chpl__tuplify(newDom.dsiStride);
    rad.factoredOffs = 0;

    rad.computeFactoredOffs();
    rad.initShiftedData();

    return rad;
  }

  //
  // Based on the old 'dsiRankChange' method
  //
  proc _remoteAccessData.toRankChange(newDom, cd, idx) {
    compilerAssert(this.rank == idx.size && this.rank != newDom.rank);
    type chpl_integralIdxType = newDom.chpl_integralIdxType;
    type idxSignedType = chpl__signedType(chpl_integralIdxType);

    // Unconditionally sets 'blkChanged'
    //
    // TODO: If 'collapsedDims' were param, we would know if blk(rank-1) was 1 or not.
    var rad : _remoteAccessData(eltType, newDom.rank, newDom.idxType, newDom.strides, true);
    const collapsedDims = chpl__tuplify(cd);

    rad.initDataFrom(this);

    rad.shiftedData = if ! newDom.hasUnitStride() then this.data else this.shiftedData;
    rad.origin      = this.origin;

    var curDim      = 0;
    for param j in 0..idx.size-1 {
      if !collapsedDims(j) {
        rad.off(curDim) = newDom.dsiDim(curDim).lowBound;
        const off       = (chpl__idxToInt(rad.off(curDim)) - chpl__idxToInt(this.off(j))):idxSignedType;
        rad.origin     += this.blk(j) * off.safeCast(int) / this.str(j);
        rad.blk(curDim) = this.blk(j);
        rad.str(curDim) = this.str(j);

        curDim += 1;
      } else {
        const off   = (chpl__idxToInt(idx(j)) - chpl__idxToInt(this.off(j))):idxSignedType;
        rad.origin += this.blk(j) *  off.safeCast(int) / this.str(j);
      }
    }

    rad.computeFactoredOffs();
    rad.initShiftedData();

    return rad;
  }

  //
  // Local cache of remote ddata access info
  //
  class LocRADCache {
    type eltType;
    param rank: int;
    type idxType;
    param strides: strideKind;
    var targetLocDom: domain(rank);
    pragma "unsafe"
    var RAD: [targetLocDom] _remoteAccessData(eltType, rank, idxType,
                                              strides);
    var RADLocks: [targetLocDom] chpl_LocalSpinlock;

    pragma "dont disable remote value forwarding"
    proc init(type eltType, param rank: int, type idxType,
              param strides: strideKind, newTargetLocDom: domain(rank)) {
      this.eltType = eltType;
      this.rank = rank;
      this.idxType = idxType;
      this.strides = strides;
      // This should resize the arrays
      targetLocDom=newTargetLocDom;
    }

    inline proc lockRAD(rlocIdx) {
      RADLocks[rlocIdx].lock();
    }

    inline proc unlockRAD(rlocIdx) {
      RADLocks[rlocIdx].unlock();
    }
  }

  class DefaultRectangularArr: BaseRectangularArr(?) {
    // inherits rank, idxType, strides, eltType

    type idxSignedType = chpl__signedType(chpl__idxTypeToIntIdxType(idxType));

    var dom : unmanaged DefaultRectangularDom(rank=rank, idxType=idxType,
                                              strides=strides);
    var off: rank*idxType;
    var blk: rank*int;
    var sizesPerDim: rank*int;
    var str: rank*idxSignedType;
    var factoredOffs: int;

    pragma "alias scope from this"
    pragma "local field"
    var data : _ddata(eltType) = nil;

    pragma "alias scope from this"
    pragma "local field"
    var shiftedData : _ddata(eltType);

    // note: used for external array support
    var externFreeFunc: c_ptr(void);
    var externArr: bool = false;
    var _borrowed: bool = true;
    // should the comms post-alloc be called after initialization?
    var callPostAlloc: bool = true;

    var deinitElts: bool = true;
    //var numelm: int = -1; // for correctness checking

    // fields end here

    proc init(type eltType, param rank, type idxType,
              param strides,
              dom:unmanaged DefaultRectangularDom(rank=rank, idxType=idxType,
                                                  strides=strides),
              param initElts = true,
              param deinitElts = initElts,
              data:_ddata(eltType) = nil,
              externArr = false,
              _borrowed = false,
              externFreeFunc: c_ptr(void) = nil) {
      super.init(eltType=eltType, rank=rank,
                 idxType=idxType, strides=strides);
      this.dom = dom;
      this.data = data;
      this.externFreeFunc = externFreeFunc;
      this.externArr = externArr;
      this._borrowed = _borrowed;
      this.callPostAlloc = false;
      this.deinitElts = deinitElts;

      init this;
      this.setupFieldsAndAllocate(initElts);
    }

    proc chpl_integralIdxType type {
      return chpl__idxTypeToIntIdxType(idxType);
    }

    override proc dsiDisplayRepresentation() {
      writeln("off=", off);
      writeln("blk=", blk);
      writeln("str=", str);
      writeln("factoredOffs=", factoredOffs);
    }

    // can the compiler create this automatically?
    override proc dsiGetBaseDom() do return dom;

    override proc dsiElementInitializationComplete() {
      const size = if storageOrder == ArrayStorageOrder.RMO
                   then blk(0) * dom.dsiDim(0).sizeAs(int)
                   else blk(rank-1) * dom.dsiDim(rank-1).sizeAs(int);

      if debugDefaultDist {
        chpl_debug_writeln("*** DR calling postalloc ", eltType:string, " ",
                           size);
      }

      if callPostAlloc {
        _ddata_allocate_postalloc(data, size);
        callPostAlloc = false;
      }

      deinitElts = true;
    }

    override proc dsiElementDeinitializationComplete() {
      deinitElts = false;
    }

    //
    // This small kernel must be implemented by different array shapes due
    // to 'BaseArr' having no notion of indexing scheme.
    //
    // TODO: Without this where clause any code using `unsafeAssign` to
    // resize a 2D+ array will explode, because the 'locales' array tries
    // to reuse an existing instantiation. Comment this out and run
    // 'test/domains/unsafeAssign/DefaultRectangular2D.chpl' to see.
    //
    override proc chpl_unsafeAssignIsClassElementNil(manager, idx)
    where idx.type == (rank*idxType) {
      ref elem = this.dsiAccess(idx);
      return manager.isClassReferenceNil(elem);
    }

    override proc dsiDestroyArr(deinitElts:bool) {
      // give up early if the array's data has already been stolen
      if data == nil {
        return;
      }

      if debugDefaultDist {
        chpl_debug_writeln("*** DR calling dealloc ", eltType:string);
      }

      if (externArr) {
        if (!_borrowed) {
          chpl_call_free_func(externFreeFunc, c_ptrTo(data));
        }
      } else {
        var numInd = dom.dsiNumIndices;
        var numElts = numInd;
        if deinitElts && this.deinitElts && numInd > 0 {
          param needsDestroy = __primitive("needs auto destroy",
                                           __primitive("deref", data[0]));

          if needsDestroy {
            if _deinitElementsIsParallel(eltType, numElts) {
              forall i in 0..#numElts {
                chpl__autoDestroy(data[i]);
              }
            } else {
              for i in 0..#numElts {
                chpl__autoDestroy(data[i]);
              }
            }
          }
        }
        _ddata_free(data, numInd);
      }
    }

    inline proc theData ref {
      if earlyShiftData && hasUnitStride() then
        return shiftedData;
      else
        return data;
    }

    //
    // Simple-ddata iterators (locale models without sublocales)
    //
    iter these(tasksPerLocale:int = dataParTasksPerLocale,
               ignoreRunning:bool = dataParIgnoreRunningTasks,
               minIndicesPerTask:int = dataParMinGranularity) ref {
      if debugDefaultDist {
        chpl_debug_writeln("*** In defRectArr simple-dd serial iterator");
      }
      for elem in chpl__serialViewIter(this, dom) do yield elem;
    }

    iter these(param tag: iterKind,
               tasksPerLocale = dataParTasksPerLocale,
               ignoreRunning = dataParIgnoreRunningTasks,
               minIndicesPerTask = dataParMinGranularity)
      ref where tag == iterKind.standalone {
      if debugDefaultDist {
        chpl_debug_writeln("*** In defRectArr simple-dd standalone iterator");
      }
      foreach i in dom.these(tag, tasksPerLocale,
                         ignoreRunning, minIndicesPerTask) with (ref this) {
        yield dsiAccess(i);
      }
    }

    iter these(param tag: iterKind,
               tasksPerLocale = dataParTasksPerLocale,
               ignoreRunning = dataParIgnoreRunningTasks,
               minIndicesPerTask = dataParMinGranularity)
      where tag == iterKind.leader {
      if debugDefaultDist {
        chpl_debug_writeln("*** In defRectArr simple-dd leader iterator");
      }
      for followThis in dom.these(tag,
                                  tasksPerLocale,
                                  ignoreRunning,
                                  minIndicesPerTask) do
        yield followThis;
    }

    iter these(param tag: iterKind, followThis,
               tasksPerLocale = dataParTasksPerLocale,
               ignoreRunning = dataParIgnoreRunningTasks,
               minIndicesPerTask = dataParMinGranularity)
      ref where tag == iterKind.follower {
      if followThis.size != this.rank then
        compilerError("rank mismatch in zippered iteration (can't zip a " +
                      followThis.size:string + "D expression with a " +
                      this.rank:string + "D array)");

      if debugDefaultDist {
        chpl_debug_writeln("*** In defRectArr simple-dd follower iterator: ",
                           followThis);
      }

      foreach i in dom.these(tag=iterKind.follower, followThis,
                         tasksPerLocale,
                         ignoreRunning,
                         minIndicesPerTask) do
        yield dsiAccess(i);
    }

    proc computeFactoredOffs() {
      factoredOffs = 0;
      for param i in 0..rank-1 do {
        factoredOffs = factoredOffs + blk(i) * chpl__idxToInt(off(i)):int;
      }
    }

    inline proc initShiftedData() {
      if earlyShiftData && hasUnitStride() {
        // Lydia note 11/04/15: a question was raised as to whether this
        // check on dsiNumIndices added any value.  Performance results
        // from removing this line seemed inconclusive, which may indicate
        // that the check is not necessary, but it seemed like unnecessary
        // work for something with no immediate reward.
        if dom.dsiNumIndices > 0 {
          const shiftDist = if isIntType(idxType) then
                              0:idxType - factoredOffs
                            else
                              // Not bothering to check for over/underflow
                              0:idxSignedType - factoredOffs:idxSignedType;
          shiftedData = _ddata_shift(eltType, data, shiftDist);
        }
      }
    }

    proc setupFieldsAndAllocate(param initElts) {
      for param dim in 0..rank-1 {
        off(dim) = dom.dsiDim(dim).low;
        str(dim) = dom.dsiDim(dim).stride;
      }
      if storageOrder == ArrayStorageOrder.RMO {
        blk(rank-1) = 1;
        for param dim in 0..(rank-2) by -1 do
          blk(dim) = blk(dim+1) * dom.dsiDim(dim+1).sizeAs(int);
      } else if storageOrder == ArrayStorageOrder.CMO {
        blk(0) = 1;
        for param dim in 1..rank-1 {
          blk(dim) = blk(dim-1) * dom.dsiDim(dim-1).sizeAs(int);
        }
      } else {
        halt("unknown array storage order");
      }
      computeFactoredOffs();
      const size = if storageOrder == ArrayStorageOrder.RMO
                   then blk(0) * dom.dsiDim(0).sizeAs(int)
                   else blk(rank-1) * dom.dsiDim(rank-1).sizeAs(int);

      if usePollyArrayIndex {
        for param dim in 0..rank-1 {
          sizesPerDim(dim) = dom.dsiDim(dim).sizeAs(int);
        }
      }

      // Allow DR array initialization to pass in existing data
      if data == nil {
        if debugDefaultDist {
          chpl_debug_writeln("*** DR alloc ", eltType:string, " ", size);
        }

        data = _ddata_allocate_noinit(eltType, size, callPostAlloc);

        if initElts {
          init_elts(data, size, eltType);
          dsiElementInitializationComplete();
        }
      }

      initShiftedData();
    }

    inline proc getDataIndex(ind: idxType ...1,
                             param getShifted = true)
      where rank == 1 do
      return getDataIndex(ind, getShifted=getShifted);

    inline proc getDataIndex(ind: rank*idxType,
                             param getShifted = true) {
      if !hasUnitStride() {
        var sum = 0;
        for param i in 0..rank-1 do
          sum += (chpl__idxToInt(ind(i)) - chpl__idxToInt(off(i))).safeCast(int) * blk(i) / abs(str(i));
        return sum;
      } else {
        param wantShiftedIndex = getShifted && earlyShiftData;

        // optimize common case to get cleaner generated code
        if (rank == 1 && wantShiftedIndex) {
          return chpl__idxToInt(ind(0)):int;
        } else {
          var sum = 0;
          var useInd = ind;
          var useOffset:int = 0;
          var useSizesPerDim = sizesPerDim;

          if usePollyArrayIndex {
            // Polly works better if we provide 0-based indices from the start.
            // So instead of using factoredOffs at the end, we initially subtract
            // the dimension offsets from the index subscripts beforehand.
            if !wantShiftedIndex {
             for param i in 0..rank-1 do {
               useInd(i) = chpl__idxToInt(useInd(i)) - chpl__idxToInt(off(i));
             }
           }
           return polly_array_index(useOffset, (...useSizesPerDim), (...useInd));
          } else {
            if storageOrder == ArrayStorageOrder.RMO {
              for param i in 0..rank-2 {
                sum += chpl__idxToInt(ind(i)):int * blk(i);
              }
              sum += chpl__idxToInt(ind(rank-1)):int;
            } else {
              for param i in 1..rank-1 {
                sum += chpl__idxToInt(ind(i)):int * blk(i);
              }
              sum += chpl__idxToInt(ind(0)):int;
            }
            if !wantShiftedIndex then sum -= factoredOffs;
            return sum;
          }
        }
      }
    }

    // only need second version (ind : rank*idxType)
    // because wrapper record can pass a 1-tuple
    inline proc dsiAccess(ind: idxType ...1) ref
    where rank == 1 do
      return dsiAccess(ind);

    inline proc dsiAccess(ind: idxType ...1)
    where rank == 1 && shouldReturnRvalueByValue(eltType) do
      return dsiAccess(ind);

    inline proc dsiAccess(ind: idxType ...1) const ref
    where rank == 1 do
      return dsiAccess(ind);

    inline proc dsiAccess(const in ind : rank*idxType) ref {
      // Note: bounds checking occurs in ChapelArray for this type.
      var dataInd = getDataIndex(ind);
      return theData(dataInd);
    }

    inline proc dsiAccess(const in ind : rank*idxType)
    where shouldReturnRvalueByValue(eltType) {
      // Note: bounds checking occurs in ChapelArray for this type.
      var dataInd = getDataIndex(ind);
      return theData(dataInd);
    }

    inline proc dsiAccess(const in ind : rank*idxType) const ref {
      // Note: bounds checking occurs in ChapelArray for this type.
      var dataInd = getDataIndex(ind);
      return theData(dataInd);
    }


    inline proc dsiBoundsCheck(i) {
      return dom.dsiMember(i);
    }

    proc adjustBlkOffStrForNewDomain(d: unmanaged DefaultRectangularDom,
                                     alias: unmanaged DefaultRectangularArr)
    {
      for param i in 0..rank-1 {
        var s: idxType;
        // NOTE: Not bothering to check to see if this can fit into idxType
        if idxSignedType==idxType {
          s = (dom.dsiDim(i).stride / str(i)) : d.idxType;
        } else { // unsigned type, signed stride
          assert((dom.dsiDim(i).stride<0 && str(i)<0) ||
                 (dom.dsiDim(i).stride>0 && str(i)>0));
          s = (dom.dsiDim(i).stride / str(i)) : d.idxType;
        }
        alias.off(i) = d.dsiDim(i).lowBound;
        alias.blk(i) = blk(i) * s;
        alias.str(i) = d.dsiDim(i).stride;
      }
    }

    proc adjustBlkOffStrForNewDomain(d: unmanaged DefaultRectangularDom,
                                     alias: unmanaged DefaultRectangularArr)
      where dom.hasUnitStride() && this.hasUnitStride()
    {
      for param i in 0..rank-1 {
        alias.off(i) = d.dsiDim(i).lowBound;
        alias.blk(i) = blk(i);
        alias.str(i) = d.dsiDim(i).stride;
      }
    }

    // Reallocate the array to have space for elements specified by `bounds`
    pragma "ignore transfer errors"
    override proc dsiReallocate(bounds: rank*range(idxType,
                                                   boundKind.both,
                                                   strides)) {

      if externArr || _borrowed then
        halt("This domain cannot be modified because it is used to define array views");

      // check to see whether this realloc is actually changing the
      // bounds of the array
      var actuallyResizing = false;
      for i in bounds.indices {
        if bounds(i) != dom.dsiDim(i) {
          actuallyResizing = true;
          break;
        }
      }

      if !actuallyResizing then
        return;

      if _resizePolicy == chpl_ddataResizePolicy.normalInit then
        if !isDefaultInitializable(eltType) then
          halt("Can't resize domains whose arrays' elements don't " +
               "have default values");

      if this.locale != here {
        halt("internal error: dsiReallocate() can only be called " +
             "from an array's home locale");
      } else {
        const reallocD = {(...bounds)};

        // For now, we'll use realloc for 1D, non-empty arrays when
        // the low bounds and strides of the old and new domains
        // match; and when the element type is POD or the array is
        // growing (i.e.,(doesn't require deinit to be called).
        const oldSize = dom.dsiNumIndices;
        const newSize = reallocD.sizeAs(oldSize.type);
        if (!disableArrRealloc && rank == 1 &&
            reallocD.lowBound == dom.dsiLow && reallocD.stride == dom.dsiStride &&
            dom.dsiNumIndices > 0 && reallocD.size > 0 &&
            _ddata_supports_reallocate(data, eltType, oldSize, newSize)) {

          if reportInPlaceRealloc then
            writeln("reallocating in-place");

          sizesPerDim(0) = reallocD.dsiDim(0).sizeAs(int);
          data = _ddata_reallocate(oldDdata=data,
                                   eltType=eltType,
                                   oldSize=oldSize,
                                   newSize=newSize,
                                   subloc=c_sublocid_none,
                                   policy=_resizePolicy);
          initShiftedData();
        } else {

          // Should have been checked above.
          param initElts = isDefaultInitializable(eltType);

          var copy = new unmanaged
              DefaultRectangularArr(eltType=eltType,
                                    rank=rank,
                                    idxType=idxType,
                                    strides=reallocD._value.strides,
                                    dom=reallocD._value,
                                    initElts=initElts);

          // May have to prepare the buffer based on the resize policy,
          // but only if the element type is non-default-initializable.
          if !initElts {
            select _resizePolicy {

              // User-facing error occurs above this scope.
              when chpl_ddataResizePolicy.normalInit do
                halt("internal error: bad resize policy for array of " +
                     "non-default-initializable elements");

              // Do nothing.
              when chpl_ddataResizePolicy.skipInit do;

              // TODO: An upgrade would be to zero out only new slots.
              when chpl_ddataResizePolicy.skipInitButClearMem do
                _ddata_fill(copy.data, eltType, 0, reallocD.size);
            }
          }

          var keep = reallocD((...dom.ranges));

          // Copy the preserved elements
          forall i in keep {
            // "move" from the old buffer to the new one
            ref dst = copy.dsiAccess(i);
            const ref src = dsiAccess(i);
            __primitive("=", dst, src);
          }

          // Deinit the other elements if
          //  * the type uses deinit
          //  * the new array has fewer elements than the old
          param needsDestroy = __primitive("needs auto destroy", eltType);
          if needsDestroy {
            if reallocD.size < dom.dsiNumIndices {
              if _deinitElementsIsParallel(eltType, dom.dsiNumIndices) {
                forall i in dom {
                  if !keep.contains(i) {
                    chpl__autoDestroy(dsiAccess(i));
                  }
                }
              } else {
                for i in dom {
                  if !keep.contains(i) {
                    chpl__autoDestroy(dsiAccess(i));
                  }
                }
              }
            }
          }

          off = copy.off;
          blk = copy.blk;
          str = copy.str;
          factoredOffs = copy.factoredOffs;

          dsiDestroyArr(deinitElts=false);
          data = copy.data;
          // We can't call initShiftedData here because the new domain
          // has not yet been updated (this is called from within the
          // = function for domains.
          if earlyShiftData && reallocD._value.hasUnitStride() {
            // Lydia note 11/04/15: a question was raised as to whether this
            // check on numIndices added any value.  Performance results
            // from removing this line seemed inconclusive, which may indicate
            // that the check is not necessary, but it seemed like unnecessary
            // work for something with no immediate reward.
            if reallocD.sizeAs(uint) > 0 {
              shiftedData = copy.shiftedData;
            }
          }
          delete copy;
        }
      }
    }

    override proc dsiPostReallocate() {
      // No action necessary here
    }

    proc dsiLocalSlice(ranges) {
      halt("all dsiLocalSlice calls on DefaultRectangulars should be handled in ChapelArray.chpl");
    }

    proc dsiGetRAD() {
      var rad: _remoteAccessData(eltType, rank, idxType, strides);
      rad.off = off;
      rad.blk = blk;
      rad.str = str;
      rad.origin = 0;
      rad.factoredOffs = factoredOffs;
      rad.data = data;
      rad.shiftedData = shiftedData;
      return rad;
    }

    proc dsiTargetLocales() const ref {
      return chpl_getSingletonLocaleArray(this.locale);
    }

    proc dsiHasSingleLocalSubdomain() param do return true;

    proc dsiLocalSubdomain(loc: locale) {
      if this.data.locale == loc {
        return _getDomain(dom);
      } else {
        var a: domain(rank, idxType, strides);
        return a;
      }
    }

    iter dsiLocalSubdomains(loc: locale) {
      yield dsiLocalSubdomain(loc);
    }

    override proc dsiIteratorYieldsLocalElements() param {
      return true;
    }
  }

  // This is specialized to avoid overheads of calling dsiAccess()
  iter chpl__serialViewIter1D(arr, viewRange) ref
      where chpl__isDROrDRView(arr) {

    param useCache = chpl__isArrayView(arr) && arr.shouldUseIndexCache();
    var info = if useCache then arr.indexCache
               else if arr.isSliceArrayView() then arr.arr
               else arr;

    if viewRange.hasUnitStride() {
      // Ideally we would like to be able to do something like
      // "for i in first..last by step". However, right now that would
      // result in a strided iterator which isn't as optimized. It would
      // also add a range initializer, which in tight loops is pretty
      // expensive. Instead we use a direct range iterator that is
      // optimized for positively strided ranges. It should be just as fast
      // as directly using a "c for loop", but it contains code check for
      // overflow and invalid strides as well as the ability to use a less
      // optimized iteration method if users are concerned about range
      // overflow.

      const first  = info.getDataIndex(viewRange.low);
      const second = info.getDataIndex(chpl__intToIdx(viewRange.idxType, chpl__idxToInt(viewRange.low)+1));
      const step   = (second-first);
      const last   = first + (viewRange.size:step.type-1) * step;
      foreach i in chpl_direct_pos_stride_range_iter(first, last, step)
          with (ref info) {
        yield info.theData(i);
      }
    } else {
      type vdIntIdxType = chpl__idxTypeToIntIdxType(viewRange.idxType);
      const stride = viewRange.stride: vdIntIdxType,
            start  = viewRange.first,
            second = info.getDataIndex(chpl__intToIdx(viewRange.idxType, viewRange.firstAsInt + stride));

      var   first  = info.getDataIndex(start);
      const step   = (second-first).safeCast(int);
      var   last   = first + (viewRange.sizeAs(int)-1) * step;

      if step < 0 then
        last <=> first;

      var data = info.theData;
      foreach i in first..last by step do
        yield data(i);
    }

  }

  iter chpl__serialViewIter(arr, viewDom) ref
    where chpl__isDROrDRView(arr) {
    param useCache = chpl__isArrayView(arr) && arr.shouldUseIndexCache();
    var info = if useCache then arr.indexCache
               else if arr.isSliceArrayView() then arr.arr
               else arr;
    if arr.rank == 1 {
      foreach elem in chpl__serialViewIter1D(arr, viewDom.dsiDim[0]) do
        yield elem;
    } else if useCache {
      foreach i in viewDom {
        const dataIdx = info.getDataIndex(i);
        yield info.getDataElem(dataIdx);
      }
    } else {
      foreach elem in chpl__serialViewIterHelper(arr, viewDom) do yield elem;
    }
  }

  iter chpl__serialViewIter(arr, viewDom) ref {
    for elem in chpl__serialViewIterHelper(arr, viewDom) do yield elem;
  }

  iter chpl__serialViewIter1D(arr, viewDom) ref {
    for elem in chpl__serialViewIterHelper(arr, viewDom) do yield elem;
  }

  iter chpl__serialViewIterHelper(arr, viewDom) ref {
    foreach i in viewDom {
      const dataIdx = if arr.isReindexArrayView() then chpl_reindexConvertIdx(i, arr.dom, arr.downdom)
                      else if arr.isRankChangeArrayView() then chpl_rankChangeConvertIdx(i, arr.collapsedDim, arr.idx)
                      else i;
      const info = if chpl__isArrayView(arr) then arr.arr else arr;
      yield info.dsiAccess(dataIdx);
    }
  }

  // Workaround: moved out of DefaultRectangularDom.dsiSerialReadWrite and
  // chpl_serialReadWriteRectangularHelper and added explicit f formal to
  // work around Dyno nested proc issues.
  // Anna, 2025-03-04
  private inline proc rwLiteral(f, lit:string) throws {
    if f._writing then f.writeLiteral(lit); else f.readLiteral(lit);
  }

  proc DefaultRectangularDom.dsiSerialReadWrite(f /*: Reader or Writer*/) throws {
    rwLiteral(f, "{");
    var first = true;
    for i in 0..rank-1 {
      if !first then rwLiteral(f, ", ");
      else first = false;

      if f._writing then f.write(ranges(i));
      else ranges(i) = f.read(ranges(i).type);
    }
    rwLiteral(f, "}");
  }

  proc DefaultRectangularDom.dsiSerialWrite(f) throws
  where _supportsSerializers(f) && !isDefaultSerializerType(f.serializerType) {
    if chpl_warnUnstable then
      compilerWarning("Serialization of rectangular domains with non-default Serializer is unstable, and may change in the future");
    var ser = f.serializer.startList(f, rank);
    for i in 0..<rank do ser.writeElement(dsiDim(i));
    ser.endList();
  }

  // TODO: There is currently a bug when returning domains from
  // 'deserializeFrom', so this isn't tested yet.
  proc DefaultRectangularDom.dsiSerialRead(f) throws
  where _supportsSerializers(f) && f.deserializerType != IO.defaultDeserializer {
    if chpl_warnUnstable then
      compilerWarning("Deserialization of rectangular domains with non-default Deserializer is unstable, and may change in the future");
    var des = f.deserializer.startList(f);
    for i in 0..<rank do ranges(i) = des.readElement(ranges(i).type);
    des.endList();
  }

  proc DefaultRectangularDom.doiToString() {
    var str = "{" + ranges(0):string;
    for i in 1..<rank do
      str += ", " + ranges(i):string;
    str += "}";
    return str;
  }

  proc DefaultRectangularDom.dsiSerialWrite(f) throws { this.dsiSerialReadWrite(f); }
  proc DefaultRectangularDom.dsiSerialRead(f) throws { this.dsiSerialReadWrite(f); }

  proc DefaultRectangularArr.dsiSerialReadWrite(f /*: Reader or Writer*/) throws {
    chpl_serialReadWriteRectangular(f, this);
  }

  override proc DefaultRectangularDom.dsiSupportsAutoLocalAccess() param {
    return defaultRectangularSupportsAutoLocalAccess;
  }

  override proc DefaultRectangularDom.dsiSupportsArrayViewElision() param {
    return true;
  }

  override proc DefaultRectangularDom.dsiSupportsShortArrayTransfer() param {
    return true;
  }

  // Why can the following two functions not be collapsed into one
  // where 'dom = arr.dom'?  Because this puts a type constraint on
  // what 'dom' can be passed that is too strict in some callchains
  // (e.g., if arr.dom is non-stridable but the 'dom' passed in is
  // stridable).
  //
  proc chpl_serialReadWriteRectangular(f, arr) throws {
    chpl_serialReadWriteRectangular(f, arr, arr.dom);
  }

  // ReplicatedDist declares a version of this method with a 'where'
  // clause, but current resolution rules prefer the more visible
  // function (rather than the one with a 'where' clause) and this
  // call is more visible (e.g. ArrayViewSlice uses DefaultRectangular
  // but not ReplicatedDist). Applying "last resort" to this function
  // requests the compiler prefer another overload if one is applicable.
  // Overload sets (or a similar idea) would be a better user-facing
  // way to solve this problem (see CHIP 20).
  pragma "last resort"
  proc chpl_serialReadWriteRectangular(f, arr, dom) throws {
    chpl_serialReadWriteRectangularHelper(f, arr, dom);
  }

  proc _supportsBulkElements(f, arr) param : bool {
    use Reflection;
    var temp : c_ptr(arr.eltType);
    if f._writing then
      return Reflection.canResolveMethod(f.serializer, "writeBulkElements", f, temp, 0:uint);
    else
      return Reflection.canResolveMethod(f.deserializer, "readBulkElements", f, temp, 0:uint);
  }

  proc _supportsSerializers(f) param : bool {
    if f._writing then return f.serializerType != nothing;
    else return f.deserializerType != nothing;
  }

  // Workaround: Moved out of chpl_serialReadWriteRectangularHelper and added
  // formals as needed, to avoid issues with generic parent procs and variable
  // capture.
  // Anna, 2025-03-04
  private proc recursiveArrayReaderWriter(f, arr, dom, ref helper, in idx, dim=0, in last=false) throws {
    param rank = arr.rank;
    type idxType = arr.idxType;
    type idxSignedType = chpl__signedType(chpl__idxTypeToIntIdxType(idxType));

    type strType = idxSignedType;
    const makeStridePositive = if dom.dsiDim(dim).stride > 0 then 1:strType else (-1):strType;

    if f._writing then
      helper.startDim(dom.dsiDim(dim).size);
    else
      helper.startDim();

    // The simple 1D case
    if dim == rank-1 {
      for j in dom.dsiDim(dim) by makeStridePositive {
        idx(dim) = j;
        if f._writing then
          helper.writeElement(arr.dsiAccess(idx));
        else {
          arr.dsiAccess(idx) = helper.readElement(arr.eltType);
        }
      }
    } else {
      for j in dom.dsiDim(dim) by makeStridePositive {
        var lastIdx =  dom.dsiDim(dim).last;
        idx(dim) = j;

        recursiveArrayReaderWriter(f, arr, dom, helper, idx, dim=dim+1,
                             last=(last || dim == 0) && (j == dom.dsiDim(dim).high));

      }
    }

    helper.endDim();
  }

  proc chpl_serialReadWriteRectangularHelper(f, arr, dom) throws
  where _supportsSerializers(f) {
    param rank = arr.rank;
    type idxType = arr.idxType;
    type idxSignedType = chpl__signedType(chpl__idxTypeToIntIdxType(idxType));

    var helper = if f._writing then
      f.serializer.startArray(f, dom.dsiNumIndices:int)
    else
      f.deserializer.startArray(f);

    use Reflection;
    var dummy : c_ptr(arr.eltType);
    param canResolveBulkElements = Reflection.canResolveMethod(helper, "writeBulkElements", dummy, 0) ||
                                   Reflection.canResolveMethod(helper, "readBulkElements", dummy, 0);
    param useBulkElements = canResolveBulkElements &&
                            arr.isDefaultRectangular() &&
                            !chpl__isArrayView(arr) &&
                            _isSimpleIoType(arr.eltType);

    const len = dom.dsiNumIndices:int;
    var dataLoc = if len > 0 then arr.dsiAccess(dom.dsiFirst).locale
                  else here;
    if useBulkElements && arr.isDataContiguous(dom) && len > 0 &&
      f._home == dataLoc {
      var ptr = c_addrOf(arr.dsiAccess(dom.dsiFirst));
      if f._writing then
        helper.writeBulkElements(ptr, len);
      else
        helper.readBulkElements(ptr, len);
    } else {
      // Otherwise, recursively read or write the array
      const zeroTup: arr.rank*arr.idxType;
      recursiveArrayReaderWriter(f, arr, dom, helper, zeroTup);
    }

    helper.endArray();
  }

  proc chpl_serialReadWriteRectangularHelper(f, arr, dom) throws {
    param rank = arr.rank;
    type idxType = arr.idxType;
    type idxSignedType = chpl__signedType(chpl__idxTypeToIntIdxType(idxType));
    type eltType = arr.eltType;

    const isNative = f.styleElement(QIO_STYLE_ELEMENT_IS_NATIVE_BYTE_ORDER): bool;

    proc rwSpaces(dim:int) throws {
      for i in 1..dim {
        rwLiteral(f, " ");
      }
    }

    proc recursiveArrayReaderWriter(in idx: rank*idxType, dom: domain, dim=0, in last=false) throws {

      var binary = f._binary();
      var arrayStyle = f.styleElement(QIO_STYLE_ELEMENT_ARRAY);
      var isspace = arrayStyle == QIO_ARRAY_FORMAT_SPACE && !binary;
      var isjson = arrayStyle == QIO_ARRAY_FORMAT_JSON && !binary;
      var ischpl = arrayStyle == QIO_ARRAY_FORMAT_CHPL && !binary;

      type strType = idxSignedType;
      var makeStridePositive = if dom.dsiDim(dim).stride > 0 then 1:strType else (-1):strType;

      if isjson || ischpl {
        if dim != rank-1 {
          rwLiteral(f, "[\n");
          rwSpaces(dim+1); // space for the next dimension
        } else rwLiteral(f, "[");
      }

      if dim == rank-1 {
        var first = true;
        if debugDefaultDist && f._writing then f.writeln(dom.dsiDim(dim));
        for j in dom.dsiDim(dim) by makeStridePositive {
          if first then first = false;
          else if isspace then rwLiteral(f, " ");
          else if isjson || ischpl then rwLiteral(f, ", ");
          idx(dim) = j;
          if f._writing then f.write(arr.dsiAccess(idx));
          else arr.dsiAccess(idx) = f.read(eltType);
        }
      } else {
        for j in dom.dsiDim(dim) by makeStridePositive {
          var lastIdx =  dom.dsiDim(dim).last;
          idx(dim) = j;

          recursiveArrayReaderWriter(idx, dom, dim=dim+1,
                               last=(last || dim == 0) && (j == dom.dsiDim(dim).high));

          if isjson || ischpl {
            if j != lastIdx {
              rwLiteral(f, ",\n");
              rwSpaces(dim+1);
            }
          }
        }
      }

      if isspace {
        if !last && dim != 0 {
          rwLiteral(f, "\n");
        }
      } else if isjson || ischpl {
        if dim != rank-1 {
          rwLiteral(f, "\n");
          rwSpaces(dim); // space for this dimension
          rwLiteral(f, "]");
        }
        else rwLiteral(f, "]");
      }
    }

    if arr.isDefaultRectangular() && !chpl__isArrayView(arr) &&
       _isSimpleIoType(arr.eltType) && f._binary() &&
       isNative && arr.isDataContiguous(dom) {

      // If we can, we would like to read/write the array as a single write op
      // since _ddata is just a pointer to the memory location we just pass
      // that along with the size of the array. This is only possible when the
      // byte order is set to native or its equivalent.
      const elemSize = c_sizeof(arr.eltType);
      if boundsChecking {
        var rw = if f._writing then "write" else "read";
        assert((dom.dsiNumIndices:uint*elemSize:uint) <= max(c_ssize_t):uint,
               "length of array to ", rw, " is greater than c_ssize_t can hold");
      }

      const len = dom.dsiNumIndices;
      const src = arr.theData;
      const idx = arr.getDataIndex(dom.dsiLow);
      const size = len:c_ssize_t*elemSize:c_ssize_t;
      try {
        if f._writing {
          f.writeBinary(c_ptrTo(_ddata_shift(arr.eltType, src, idx)[0]), size);
        } else {
          f.readBinary(c_ptrTo(_ddata_shift(arr.eltType, src, idx)[0]), size);
        }
      } catch err {
        // Setting errors in channels has no effect, so just rethrow.
        throw err;
      }
    } else {
      const zeroTup: rank*idxType;
      recursiveArrayReaderWriter(zeroTup, dom);
    }
  }

  proc DefaultRectangularArr.dsiSerialWrite(f) throws {
    dsiSerialReadWrite(f);
  }

  proc DefaultRectangularArr.dsiSerialRead(f) throws {
    dsiSerialReadWrite(f);
  }

  inline proc DefaultRectangularArr.isDataContiguous(dom: domain) {
    return isDataContiguous(dom._value);
  }

  // This is very conservative.
  inline proc DefaultRectangularArr.isDataContiguous(dom: range) {
    if rank != 1 then return false;

    if debugDefaultDistBulkTransfer then
      chpl_debug_writeln("isDataContiguous(): off=", off, " blk=", blk);

    if blk(rank-1) != 1 then return false;

    if debugDefaultDistBulkTransfer then
      chpl_debug_writeln("\tYES!");

    return true;
  }

  // This is very conservative.
  proc DefaultRectangularArr.isDataContiguous(dom) {
    if debugDefaultDistBulkTransfer then
      chpl_debug_writeln("isDataContiguous(): off=", off, " blk=", blk);

    if blk(rank-1) != 1 then return false;

    if rank >= 2 {
      const domDims = dom.dsiDims();
      for param dim in 0..(rank-2) by -1 do
        if blk(dim) != blk(dim+1)*domDims(dim+1).sizeAs(int) then return false;
    }

    if debugDefaultDistBulkTransfer then
      chpl_debug_writeln("\tYES!");

    return true;
  }

  private proc _canDoSimpleTransfer(A, aView, B, bView) {
    if !A.isDataContiguous(aView) || !B.isDataContiguous(bView) {
      if debugDefaultDistBulkTransfer then
        chpl_debug_writeln("isDataContiguous return False");
      return false;
    }
    return true;
  }

  // optimization opportunity: if negative strides cancel out themselves,
  // return true and invoke complexTransferComm(), switching neg. to positive
  private proc _canDoComplexTransfer(A, aView, B, bView) {
    return useBulkTransferStride &&
           chpl_allStridesArePositive(A, aView, B, bView);
  }

  override proc DefaultRectangularArr.doiCanBulkTransferRankChange() param do return true;

  proc DefaultRectangularArr.doiBulkTransferToKnown(srcDom, destClass:DefaultRectangularArr, destDom) : bool {
    return transferHelper(destClass, destDom, this, srcDom);
  }

  proc DefaultRectangularArr.doiBulkTransferFromKnown(destDom, srcClass:DefaultRectangularArr, srcDom) : bool {
    return transferHelper(this, destDom, srcClass, srcDom);
  }

  private proc transferHelper(A, aView, B, bView) : bool {
    if A.rank == B.rank &&
       aView.hasUnitStride() && bView.hasUnitStride() &&
       _canDoSimpleTransfer(A, aView, B, bView) {
      if debugDefaultDistBulkTransfer then
        chpl_debug_writeln("Performing simple DefaultRectangular transfer");

      _simpleTransfer(A, aView, B, bView);
    } else if _canDoComplexTransfer(A, aView, B, bView) {
      if debugDefaultDistBulkTransfer then
        chpl_debug_writeln("Performing complex DefaultRectangular transfer");

      complexTransfer(A, aView, B, bView);
    } else {
      return false;
    }

    return true;
  }

  /**
    Check if the given locale and sublocale are the same as the current locale.
    This is relevant for figuring out what sort of communication to do;
    if the source is on the current locale, we can perform a 'put' call
    (transferring data to the destination). On the other hand, if the
    destination is on the current locale, we can perform a 'get' call
    (receiving data from the source).

    To decide on communication, we need to know that both the locale and
    sublocale matches. Sublocales are only in play with the GPU locale model,
    so avoid the check if we're using a different locale model.
   */
  private inline proc _isLocSublocSameAsHere(locid, sublocid) {
    use ChplConfig;

    if locid != here.id then
        return false;

    if CHPL_LOCALE_MODEL != "gpu" then
        return true;

    const heresublocid = chpl_task_getRequestedSubloc();

    // for the time being, consider all sublocale IDs less than zero to refer to
    // the parent locale (e.g. host).
    return (sublocid < 0 && heresublocid < 0) || sublocid == heresublocid;
  }

  private proc _simpleTransfer(A, aView, B, bView) {
    use ChplConfig;

    param rank     = A.rank;
    type idxType   = A.idxType;

    var Alo: rank*aView.idxType;

    if isDomain(aView) {
      const Adims = aView.dims();
      for param i in 0..rank-1 do
        Alo(i) = Adims(i).first;
    }
    else if isRange(aView) {
      Alo(0) = aView.first;
    }
    else {
      compilerError("Unexpected type");
    }

    var Blo: rank*B.idxType;
    if isDomain(bView) {
    const Bdims = bView.dims();
    for param i in 0..rank-1 do
      Blo(i) = Bdims(i).first;
    }
    else if isRange(bView) {
      Blo(0) = bView.first;
    }

    const len = aView.sizeAs(aView.chpl_integralIdxType).safeCast(c_size_t);

    if len == 0 then return;

    if debugBulkTransfer {
      pragma "fn synchronization free"
      extern proc sizeof(type x): int;
      const elemSize =sizeof(B.eltType);
      chpl_debug_writeln("In DefaultRectangular._simpleTransfer():",
              " Alo=", Alo, ", Blo=", Blo,
              ", len=", len, ", elemSize=", elemSize);
    }

    const Aidx = A.getDataIndex(Alo);
    const Adata = _ddata_shift(A.eltType, A.theData, Aidx);
    const Alocid = Adata.locale.id;
    const Asublocid = if CHPL_LOCALE_MODEL != "gpu" then c_sublocid_none else
                          chpl_sublocFromLocaleID(Adata.locale.chpl_localeid());
    const Bidx = B.getDataIndex(Blo);
    const Bdata = _ddata_shift(B.eltType, B.theData, Bidx);
    const Blocid = Bdata.locale.id;
    const Bsublocid = if CHPL_LOCALE_MODEL != "gpu" then c_sublocid_none else
                          chpl_sublocFromLocaleID(Bdata.locale.chpl_localeid());

    type t = A.eltType;
    const elemsizeInBytes = if isNumericType(t) then numBytes(t)
                            else c_sizeof(t).safeCast(int);

    // we parallelize the assignment if
    // 1. the size is above threshold
    // 2. we are either not doing communication or doing a PUT
    // See: https://github.com/Cray/chapel-private/issues/1365
    const isSizeAboveThreshold = len:int*elemsizeInBytes >= parallelAssignThreshold;
    const isFullyLocal = Alocid == Blocid && Asublocid == Bsublocid;
    var doParallelAssign = isSizeAboveThreshold && isFullyLocal;

    if enableParallelGetsInAssignment || enableParallelPutsInAssignment {
      if isSizeAboveThreshold && !isFullyLocal {
        if enableParallelPutsInAssignment && _isLocSublocSameAsHere(Blocid, Bsublocid) {
          doParallelAssign = true;
        }
        else if enableParallelGetsInAssignment && !_isLocSublocSameAsHere(Blocid, Bsublocid) {
          doParallelAssign = true;
        }
      }
    }

    if doParallelAssign {
      _simpleParallelTransferHelper(A, B, Adata, Bdata, Alocid, Asublocid,
                                    Blocid, Bsublocid, len);
    }
    else{
      _simpleTransferHelper(A, B, Adata, Bdata, Alocid, Asublocid, Blocid,
                            Bsublocid, len);
    }
  }

  private proc _simpleParallelTransferHelper(A, B, Adata, Bdata, Alocid,
                                             Asublocid, Blocid, Bsublocid,
                                             len) {
    const numTasks = if __primitive("task_get_serial") then 1
                        else _computeNumChunks(len);
    const lenPerTask = len:int/numTasks;

    if debugDefaultDistBulkTransfer && numTasks > 1 then
      chpl_debug_writeln("\tWill do parallel transfer with ", numTasks, " tasks");

    coforall tid in 0..#numTasks {
      const myOffset = tid*lenPerTask;
      const myLen = if tid == numTasks-1 then len:int-myOffset else lenPerTask;

      _simpleTransferHelper(A, B, Adata, Bdata, Alocid, Asublocid, Blocid,
                            Bsublocid, myLen, myOffset);
    }
  }

  private proc _simpleTransferHelper(A, B, Adata, Bdata, Alocid, Asublocid,
                                     Blocid, Bsublocid, len, offset=0) {
    if Adata == Bdata then return;

    // communicate to the primitive using a reference rather than a ptr
    // the primitive will copy data using these references
    const ref srcRef = Bdata[offset];
    ref dstRef = Adata[offset];

    // NOTE: This does not work with --heterogeneous, but heterogeneous
    // compilation does not work right now.  The calls to chpl_comm_get
    // and chpl_comm_put should be changed once that is fixed.
    if _isLocSublocSameAsHere(Alocid, Asublocid) {
      if debugDefaultDistBulkTransfer then
        chpl_debug_writeln("\tlocal get() from ", Blocid);

      __primitive("chpl_comm_array_get", dstRef, Blocid, Bsublocid,
                  srcRef, len);
    } else if _isLocSublocSameAsHere(Blocid, Bsublocid) {
      if debugDefaultDistBulkTransfer then
        chpl_debug_writeln("\tlocal put() to ", Alocid);

      __primitive("chpl_comm_array_put", srcRef, Alocid, Asublocid,
                  dstRef, len);
    } else on Adata.locale {
      if debugDefaultDistBulkTransfer then
        chpl_debug_writeln("\tremote get() on ", here.id, " from ", Blocid);

      __primitive("chpl_comm_array_get", dstRef, Blocid, Bsublocid,
                  srcRef, len);
    }
  }

  /*
  For more details, see: http://upc.lbl.gov/publications/upc_memcpy.pdf
    'Proposal for Extending the UPC Memory Copy Library Functions and
    Supporting Extensions to GASNet, Version 2.0. Author: Dan Bonachea'

  This function transfers B into A, where A and B are both
  DefaultRectangularArr classes.

  `aView` and `bView` represent the indices to be transferred to/from. They
  might be different if this is a transfer involving an Array View.

  Assumes row-major ordering.
  Assumes positive strides for both the source and the destination,
  because complexTransferComm() seems to require that.

  Depends on adjustBlkOffStrForNewDomain having been called in ChapelArray
  before entering this function.

  TODO: Determine if we can reduce the communication for array metadata

  TODO: Pull simple runtime implementation up into module code
  */
  private proc complexTransfer(A, aView, B, bView) {
    use ChplConfig;

    const Alocid = A.data.locale.id;
    const Asublocid = if CHPL_LOCALE_MODEL != "gpu" then c_sublocid_none else
                          chpl_sublocFromLocaleID(A.data.locale.chpl_localeid());
    const Blocid = B.data.locale.id;
    const Bsublocid = if CHPL_LOCALE_MODEL != "gpu" then c_sublocid_none else
                          chpl_sublocFromLocaleID(B.data.locale.chpl_localeid());

    if !_isLocSublocSameAsHere(Alocid, Asublocid) &&
       !_isLocSublocSameAsHere(Blocid, Bsublocid) {
      if debugDefaultDistBulkTransfer {
        chpl_debug_writeln("BulkTransferStride: Both arrays on different locale, moving to locale of destination: LOCALE", A.data.locale.id);
      }
      on A.data do
        complexTransferCore(A, Alocid, Asublocid, aView, B, Blocid, Bsublocid, bView);
    } else {
      complexTransferCore(A, Alocid, Asublocid, aView, B, Blocid, Bsublocid, bView);
    }
  }


  private proc complexTransferCore(LHS, LHSlocid, LHSsublocid, LViewDom, RHS, RHSlocid, RHSsublocid, RViewDom) {
    param minRank = min(LHS.rank, RHS.rank);
    type  idxType = LHS.idxType;
    type  chpl_integralIdxType = LHS.chpl_integralIdxType;

    if debugDefaultDistBulkTransfer {
      writeln("Transferring views :", LViewDom, " <-- ", RViewDom);
      writeln("Original domains   :", LHS.dom.dsiDims(), " <-- ", RHS.dom.dsiDims());
    }

    const LeftDims  = if isDomain(LViewDom) then LViewDom.dims()
                                            else (LViewDom,);
    const RightDims = if isDomain(RViewDom) then RViewDom.dims()
                                            else (RViewDom, );

    const (LeftActives, RightActives, inferredRank) = bulkCommComputeActiveDims(LeftDims, RightDims);

    var DimSizes: [1..inferredRank] LeftDims(0).sizeAs(int).type;
    for i in 1..inferredRank {
      const dimIdx = LeftActives(i-1);
      DimSizes[i] = LeftDims(dimIdx).sizeAs(int);
    }

    if debugDefaultDistBulkTransfer {
      writeln("inferredRank = ", inferredRank);
    }
    assert(inferredRank <= minRank, "complex DR transfer: computed rank greater than minimum rank!");

    // Compute a 'blk' tuple for the LHS and RHS based on their view-domains
    var LBlk, RBlk : minRank*int;

    {
      // For each array, compute a valid 'blk' with 'inferredRank' values
      // over the array's original data by skipping over rank-changed dims.
      for idx in 1..inferredRank by -1 {
        const li = LeftActives(idx-1);
        LBlk(idx-1) = LHS.blk(li) * (LeftDims(li).stride / LHS.dom.dsiDim(li).stride).safeCast(int);

        const ri = RightActives(idx-1);
        RBlk(idx-1) = RHS.blk(ri) * (RightDims(ri).stride / RHS.dom.dsiDim(ri).stride).safeCast(int);
      }
    }

    if debugDefaultDistBulkTransfer {
      writeln("LBlk = ", LBlk);
      writeln("RBlk = ", RBlk);
    }

    // The number of values needed to express the strided region.
    var stridelevels = 0;

    //
    // `count[1]` is the number of elements we can bulk-copy at a time. Each
    // number after that represents the number of times we need to stride at
    // each level. It will ultimately be an array of size `stridelevels+1`.
    //
    var countDom = {1..inferredRank+1};
    var count : [countDom] c_size_t;
    for c in count do c = 1; // serial to avoid task creation overhead

    //
    // The arrays representing the required stride at each level. Should pull
    // from the values in the 'blk' tuple, though we may skip a dimension if
    // it can be aggregated. Will ultimately be of size `stridelevels`.
    //
    var strideDom = {1..inferredRank};
    var dstStride, srcStride : [strideDom] c_size_t;

    //
    // If the last dimension is strided then we can only copy one element at a
    // time. `blk(rank-1)` may be greater than `1` depending on the results of
    // `adjustBlkOffStrForNewDomain` or if there was a rank change.
    //
    // It is incorrect to check the stride of the ranges here because the
    // original domain may have also been strided, like so:
    //   var A : [1..10 by 2, 1..20 by 4] int;
    //
    if LBlk(inferredRank-1) > 1 || RBlk(inferredRank-1) > 1 {
      stridelevels           += 1;
      count[stridelevels]     = 1;
      dstStride[stridelevels] = LBlk(inferredRank-1).safeCast(c_size_t);
      srcStride[stridelevels] = RBlk(inferredRank-1).safeCast(c_size_t);
    }

    //
    // When at the end of the elements in dimension `i`, `canReuseStride` tells
    // us whether or not we can re-use the current stride value to advance to
    // the next chunk of elements. If either array is unable to re-use its
    // stride, then we need a new stride value.
    //
    for i in 2..inferredRank by -1 {
      // Each corresponding dimension in A and B should have the same length,
      // so it doesn't matter which we use here.
      count[stridelevels+1] *= DimSizes(i).safeCast(c_size_t);

      const bothReuse = canReuseStride(LBlk, i, stridelevels, count, dstStride) &&
                        canReuseStride(RBlk, i, stridelevels, count, srcStride);

      if !bothReuse {
        stridelevels += 1;
        dstStride[stridelevels] = LBlk(i-2).safeCast(c_size_t);
        srcStride[stridelevels] = RBlk(i-2).safeCast(c_size_t);
      }
    }
    count[stridelevels+1] *= DimSizes(1).safeCast(c_size_t);

    assert(stridelevels <= inferredRank, "BulkTransferStride: stride levels greater than rank.");
    if stridelevels == 0 then assert(count[1] == LViewDom.sizeAs(c_size_t), "BulkTransferStride: bulk-count incorrect for stride level of 0: ", count[1], " != ", LViewDom.sizeAs(c_size_t));

    countDom  = {1..stridelevels+1};
    strideDom = {1..stridelevels};

    proc getFirstIdx(dims) {
      var ret : dims.size * dims(0).idxType;
      for param i in 0..dims.size-1 do
        ret(i) = if dims(i).stride < 0 then dims(i).last else dims(i).first;
      return ret;
    }

    // Build up the index tuples to calculate the offset for the first element
    const LFirst = getFirstIdx(LeftDims);
    const RFirst = getFirstIdx(RightDims);

    complexTransferComm(LHS, LHSlocid, LHSsublocid, RHS, RHSlocid, RHSsublocid, stridelevels:int(32), dstStride, srcStride, count, LFirst, RFirst);
  }

  //
  // Invoke the primitives chpl_comm_get_strd/puts, depending on what locale we
  // are on vs. where the source and destination are.
  //
  private proc complexTransferComm(A, Alocid, Asublocid, B, Blocid, Bsublocid, stridelevels:int(32), dstStride, srcStride, count, AFirst, BFirst) {
    use ChplConfig;
    if debugDefaultDistBulkTransfer {
      chpl_debug_writeln("BulkTransferStride with values:\n",
                    try! "\tLocale        = %?\n".format(here.id),
                    try! "\tStride levels = %?\n".format(stridelevels),
                    try! "\tdstStride     = %?\n".format(dstStride),
                    try! "\tsrcStride     = %?\n".format(srcStride),
                    try! "\tcount         = %?".format(count));
    }

    const AO = A.getDataIndex(AFirst, getShifted = false);
    const BO = B.getDataIndex(BFirst, getShifted = false);

    const dest = A.data;
    const src  = B.data;

    const dststr = dstStride._value.data;
    const srcstr = srcStride._value.data;
    const cnt    = count._value.data;

    if _isLocSublocSameAsHere(Alocid, Asublocid) {
      const srclocale = Blocid;
      const src_subloc = Bsublocid;

      if debugBulkTransfer {
        chpl_debug_writeln("BulkTransferStride: On LHS - GET from ", srclocale);
      }

      __primitive("chpl_comm_get_strd",
                  dest[AO],
                  dststr[0],
                  srclocale,
                  src_subloc,
                  src[BO],
                  srcstr[0],
                  cnt[0],
                  stridelevels);
    }
    else {
      const destlocale = Alocid;
      const dest_subloc = Asublocid;

      if debugDefaultDistBulkTransfer {
        assert(src.locale.id == here.id,
               "BulkTransferStride: Expected to be on ", src.locale.id,
               ", actually on ", here.id);
      }

      if debugBulkTransfer {
        chpl_debug_writeln("BulkTransferStride: On RHS - PUT to ", destlocale);
      }

      __primitive("chpl_comm_put_strd",
                  dest[AO],
                  dststr[0],
                  destlocale,
                  dest_subloc,
                  src[BO],
                  srcstr[0],
                  cnt[0],
                  stridelevels);
    }
  }

  override proc DefaultRectangularArr.isDefaultRectangular() param do return true;
  override proc type DefaultRectangularArr.isDefaultRectangular() param do return true;

  config param debugDRScan = false;

  /* This computes a 1D scan in parallel on the array, for 1D arrays only */
  proc DefaultRectangularArr.doiScan(op, dom) where (rank == 1) &&
                                                chpl__scanStateResTypesMatch(op) {
    use RangeChunk;

    type resType = op.generate().type;
    var res = dom.buildArray(resType, initElts=!isPOD(resType));

    // Take first pass, computing per-task partial scans, stored in 'state'
    var (numTasks, rngs, state, _) = this.chpl__preScan(op, res, dom);

    // Take second pass updating result based on the scanned 'state' if there
    // are multiple tasks
    if numTasks > 1 {
      this.chpl__postScan(op, res, numTasks, rngs, state);
    }
    if isPOD(resType) then res.dsiElementInitializationComplete();

    // Clean up and return
    delete op;
    return res;
  }

  // A helper routine that will perform a pointer swap on an array
  // instead of doing a deep copy of that array. Returns true
  // if used the optimized swap, false otherwise
  proc DefaultRectangularArr.doiOptimizedSwap(other: this.type) {
   // Get shape of array
    var size1: rank*int;
    for (i, r) in zip(0..#this.dom.ranges.size, this.dom.ranges) do
      size1(i) = r.sizeAs(int);

    // Get shape of array
    var size2: rank*int;
    for (i, r) in zip(0..#other.dom.ranges.size, other.dom.ranges) do
      size2(i) = r.sizeAs(int);

    if(this.locale == other.locale &&
       size1 == size2) {
      if debugOptimizedSwap {
        writeln("DefaultRectangular doing optimized swap. Domains: ",
                this.dom.ranges, " ", other.dom.ranges);
      }
      this.data <=> other.data;
      this.initShiftedData();
      other.initShiftedData();
      return true;
    }
    if debugOptimizedSwap {
      writeln("DefaultRectangular doing unoptimized swap. Domains: ",
              this.dom.ranges, " ", other.dom.ranges);
    }
    return false;
  }

  // The purpose of this overload is to provide debugging output in the event
  // that debugOptimizedSwap is on and the main routine doesn't resolve (e.g.,
  // due to a type, stridability, or rank mismatch in the other argument). When
  // debugOptimizedSwap is off, this overload will be ignored due to its where
  // clause.
  pragma "last resort"
  proc DefaultRectangularArr.doiOptimizedSwap(other) where debugOptimizedSwap {
    writeln("DefaultRectangularArr doing unoptimized swap. Type mismatch");
    return false;
  }

  proc DefaultRectangularArr.doiSupportsReshape() param {
    return true;
  }

  proc DefaultRectangularArr.doiReshape(dom: domain(?))
   where dom._value.isDefaultRectangular() {
    var ret = new unmanaged DefaultRectangularArr(eltType=this.eltType,
                                                  rank = dom.rank,
                                                  idxType=dom.idxType,
                                                  strides=dom.strides,
                                                  dom=dom._value,
                                                  data=this.data,
                                                  externFreeFunc=nil,
                                                  externArr=true,
                                                  _borrowed=true);
    dom._value.add_arr(ret, locking = false);
    return _newArray(ret);
  }

  // A helper routine to take the first parallel scan over a vector
  // yielding the number of tasks used, the ranges computed by each
  // task, and the scanned results of each task's scan.  This is
  // broken out into a helper function in order to be made use of by
  // distributed array scans.
  proc DefaultRectangularArr.chpl__preScan(op, ref res: [] ?resType, dom) {
    import RangeChunk;
    // Compute who owns what
    const rng = dom.dim(0);
    const numTasks = if __primitive("task_get_serial") then
                      1 else _computeNumChunks(rng.sizeAs(int));
    const rngs = RangeChunk.chunks(rng, numTasks);
    if debugDRScan {
      writeln("Using ", numTasks, " tasks");
      writeln("Whose chunks are: ", rngs);
    }

    var state: [rngs.domain] resType;

    // Take first pass over data doing per-chunk scans
    coforall tid in rngs.domain with (ref state) {
      const current: resType;
      const myop = op.clone();
      for i in rngs[tid] {
        ref elem = dsiAccess(i);
        myop.accumulate(elem);
        res[i] = myop.generate();
      }
      state[tid] = res[rngs[tid].highBound];
      delete myop;
    }

    if debugDRScan {
      writeln("res = ", res);
      writeln("state = ", state);
    }

    // Scan state vector itself
    const metaop = op.clone();
    var next: resType = metaop.identity;
    for i in rngs.domain {
      state[i] <=> next;
      metaop.accumulateOntoState(next, state[i]);
    }
    delete metaop;
    if debugDRScan then
      writeln("state = ", state);

    return (numTasks, rngs, state, next);
  }

  // A second helper routine that does the second parallel pass over
  // the result vector adding the prefix state computed by the earlier
  // tasks.  This is broken out into a helper function in order to be
  // made use of by distributed array scans.
  proc DefaultRectangularArr.chpl__postScan(op, ref res, numTasks, rngs, state) {
    coforall tid in rngs.domain {
      const myadjust = state[tid];
      for i in rngs[tid] {
        op.accumulateOntoState(res[i], myadjust);
      }
    }

    if debugDRScan then
      writeln("res = ", res);
  }



  /*
  The runtime implementation's loop over the current stride level will look
  something like this:

  ```
  for (i = 0; i < count[levels+1]; i++) {
    src = baseSrc + srcStride[levels] * i;
    dst = baseDst + dstStride[levels] * i;
    // then dimensions curDim+1..rank
  }
  ```

  The last value of `src` will be:
    baseSrc + (count[levels+1] - 1) * srcStride[levels];

  To correctly advance to the next chunk of elements, we could simply add a
  stride level and increment `baseSrc` by `blk(curDim-1)`. While correct, this
  would not be the optimal choice if we want to bulk-copy the largest possible
  chunk at a time.

  To do so, we need to determine whether or not we can re-use the current
  stride to advance to the next chunk of elements.

  When the stridelevel is less than 1, we're still calculating the bulk-copy
  size. In this case, we let the stride value be `1` in order to test that the
  next chunk is contiguous in memory.

  When the stridelevel is greater than 1 we're done calculating the bulk-copy
  size. However, it's still convenient to try and re-use the stride if
  possible.
  */
  private proc canReuseStride(blk, curDim: int, levels, count, stride)
  {
    // TODO: Do we need to return false if the previous dimension has only one
    // element? What if it only has one element in the original domain?
    //
    // So far it seems to 'just work'.

    const lastCount = count[levels+1];
    const curStride = if levels < 1 then 1 else stride[levels];

    // Subtract `1` because we don't need a stride for the first element in
    // the current stride level. We could simplify the math here, but I think
    // this is clearer.
    const lastIndex = (lastCount-1) * curStride;
    const nextIndex = lastIndex + curStride;

    return blk(curDim-2) == nextIndex;
  }

}
