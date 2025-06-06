/*
 * Copyright 2021-2025 Hewlett Packard Enterprise Development LP
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

#ifndef EXTERN_BLOCKS_H
#define EXTERN_BLOCKS_H

#include "chpl/framework/Context.h"
#include "chpl/framework/ID.h"
#include "chpl/framework/UniqueString.h"
#include "chpl/resolution/resolution-types.h"
#include "chpl/types/QualifiedType.h"

namespace chpl {
namespace resolution {

/** Given an extern block ID and a name, returns 'true' if that
    extern block defines or declares something with that name.
 */
bool externBlockContainsName(Context* context, ID externBlockId,
                             UniqueString name);

/** Given an extern block ID and a name, returns 'true' if that
    extern block defines or declares a function with that name.
 */
bool externBlockContainsFunction(Context* context, ID externBlockId,
                                 UniqueString name);

/** Given an extern block ID and a name, returns the equivalent
 *  Chapel QualifiedType for that symbol with that name.
 *  Returns an empty QualifiedType if the symbol is not found.
 */
const types::QualifiedType externBlockTypeForSymbol(Context* context,
                                                    ID externBlockId,
                                                    UniqueString name);

/** Given an extern block ID and a name, returns the equivalent
 *  Chapel TypedFnSignature for that function with that name.
 *  Returns nullptr if the function is not found.
 */
const resolution::TypedFnSignature* externBlockSigForFn(Context* context,
                                                        ID externBlockId,
                                                        UniqueString name);

/** Given an extern block ID and a name, returns the equivalent
 * Chapel QualifiedType for the return type of the function with that name.
 * Returns an empty QualifiedType if the function is not found.
 */
const types::QualifiedType externBlockRetTypeForFn(Context* context,
                                                   ID externBlockId,
                                                   UniqueString name);

}  // end namespace resolution
}  // end namespace chpl

#endif
