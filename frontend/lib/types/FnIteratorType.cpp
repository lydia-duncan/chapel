/*
 * Copyright 2024-2025 Hewlett Packard Enterprise Development LP
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

#include "chpl/types/FnIteratorType.h"
#include "chpl/framework/query-impl.h"
#include "chpl/resolution/resolution-types.h"

namespace chpl {
namespace types {

void FnIteratorType::markUniqueStringsInner(Context* context) const {
  iteratorFn_->mark(context);
  yieldType_.mark(context);
}

const owned<FnIteratorType>&
FnIteratorType::getFnIteratorType(Context* context,
                                  const resolution::PoiScope* poiScope,
                                  const resolution::TypedFnSignature* iteratorFn,
                                  QualifiedType retType) {
  QUERY_BEGIN(getFnIteratorType, context, poiScope, iteratorFn, retType);
  auto result = toOwned(new FnIteratorType(poiScope, iteratorFn, retType));
  return QUERY_END(result);
}

const FnIteratorType*
FnIteratorType::get(Context* context,
                    const resolution::PoiScope* poiScope,
                    const resolution::TypedFnSignature* iteratorFn,
                    QualifiedType retType) {
  return getFnIteratorType(context, poiScope, iteratorFn, retType).get();
}

}  // end namespace types
}  // end namespace chpl
