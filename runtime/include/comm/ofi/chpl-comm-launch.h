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

#ifndef _chpl_comm_launch_h
#define _chpl_comm_launch_h

#ifdef __cplusplus
extern "C" {
#endif

//
// Launch assistance for the ofi communication layer.
//

#include <stdint.h>

//
// This is an optional comm layer function for the launcher to call
// right before launching the user program.
//
#define CHPL_COMM_PRELAUNCH(numLocales) chpl_comm_preLaunch(numLocales)
void chpl_comm_preLaunch(int32_t numLocales);

#ifdef __cplusplus
}
#endif

#endif
