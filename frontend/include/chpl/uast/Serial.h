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

#ifndef CHPL_UAST_SERIAL_H
#define CHPL_UAST_SERIAL_H

#include "chpl/framework/Location.h"
#include "chpl/uast/BlockStyle.h"
#include "chpl/uast/AstNode.h"
#include "chpl/uast/SimpleBlockLike.h"

namespace chpl {
namespace uast {


/**
  This class represents a serial statement. For example:

  \rst
  .. code-block:: chapel

      // Example 1:
      const flag = true;
      serial flag {
        var x = 0;
        writeln(x);
      }

      // Example 2:
      var x = 0;
      serial do writeln(x);
  \endrst

 */
class Serial final : public SimpleBlockLike {
 friend class AstNode;

 private:
  int8_t condChildNum_;

  Serial(AstList children, int8_t condChildNum, BlockStyle blockStyle,
         int bodyChildNum,
         int numBodyStmts)
    : SimpleBlockLike(asttags::Serial, std::move(children), blockStyle,
                      bodyChildNum,
                      numBodyStmts),
      condChildNum_(condChildNum) {
  }

  void serializeInner(Serializer& ser) const override {
    simpleBlockLikeSerializeInner(ser);
    ser.write(condChildNum_);
  }

  explicit Serial(Deserializer& des)
    : SimpleBlockLike(asttags::Serial, des) {
    condChildNum_ = des.read<int8_t>();
  }

  bool contentsMatchInner(const AstNode* other) const override {
    const Serial* lhs = this;
    const Serial* rhs = (const Serial*) other;

    if (lhs->condChildNum_ != rhs->condChildNum_)
      return false;

    if (!lhs->simpleBlockLikeContentsMatchInner(rhs))
      return false;

    return true;
  }

  void markUniqueStringsInner(Context* context) const override {
    simpleBlockLikeMarkUniqueStringsInner(context);
  }

  std::string dumpChildLabelInner(int i) const override;

 public:

  /**
    Create and return a serial statement containing the passed statements.
  */
  static owned<Serial> build(Builder* builder, Location loc,
                             BlockStyle blockStyle,
                             AstList stmts);


  /**
    Create and return a serial statement with the given condition and
    containing the passed statements.
  */
  static owned<Serial> build(Builder* builder, Location loc,
                             owned<AstNode> condition,
                             BlockStyle blockStyle,
                             AstList stmts);

  /**
    Returns the condition of this serial statement, or nullptr if there
    is none.
  */
  const AstNode* condition() const {
    return condChildNum_ < 0 ? nullptr : child(condChildNum_);
  }
};


} // end namespace uast
} // end namespace chpl

#endif
