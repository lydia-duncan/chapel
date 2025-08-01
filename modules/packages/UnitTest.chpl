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

/*
Support for automated testing in Chapel.

The UnitTest module is intended to be used with the `mason test
<https://chapel-lang.org/docs/tools/mason/mason.html>`_ command, which
automates execution of any test function.

A unit test function is defined as any function with the following signature:

.. code-block:: chapel

  proc funcName(test: borrowed Test) throws {}

These functions must accept an argument of type ``borrowed Test``, and have a
``throws``.

A program containing tests must execute the ``UnitTest``
:proc:`~UnitTest.main()` function to run the tests.


Assert Functions
----------------

Here are the assert functions available in the UnitTest module:

- :proc:`~Test.assertTrue`
- :proc:`~Test.assertFalse`
- :proc:`~Test.assertEqual`
- :proc:`~Test.assertNotEqual`
- :proc:`~Test.assertGreaterThan`
- :proc:`~Test.assertLessThan`
- :proc:`~Test.assertRegexMatch`

Test Metadata Functions
-----------------------

UnitTest module also provides multiple methods for specifying test Metadata:

- :proc:`~Test.skip`
- :proc:`~Test.skipIf`
- :proc:`~Test.addNumLocales`
- :proc:`~Test.maxLocales`
- :proc:`~Test.minLocales`
- :proc:`~Test.dependsOn`


Examples
--------

Basic Usage
^^^^^^^^^^^

Here is a minimal example demonstrating how to use the UnitTest module:

.. code-block:: chapel

   use UnitTest;

   proc celsius2fahrenheit(x) {
     // we should be returning "(x: real * 9/5)+32"
     return (x * 9/5)+32;
   }

   proc test_temperature(test: borrowed Test) throws {
     // we were expecting 98.6 but since we missed typecasting
     // the above function returned 98.
     test.assertFalse(celsius2fahrenheit(37) == 98);
   }

   UnitTest.main();

Output:

.. code-block:: bash

  ======================================================================
  FAIL xyz.chpl: test_temperature()
  ----------------------------------------------------------------------
  AssertionError: assertFalse failed. Given expression is True

  ----------------------------------------------------------------------
  Run 1 test

  FAILED failures = 1


Skipping Tests
^^^^^^^^^^^^^^^

You can skip tests unconditionally with :proc:`~Test.skip` and
conditionally with :proc:`~Test.skipIf`:

.. code-block:: chapel

   use UnitTest;

   /* calculates factorial */
   proc factorial(x: int): int {
     return if x == 0 then 1 else x * factorial(x-1);
   }

   /*Conditional skip*/
   proc test1(test: borrowed Test) throws {
     test.skipIf(factorial(0) != 1,"Base condition is wrong in factorial");
     test.assertTrue(factorial(5) == 120);
   }

   /*Unconditional skip*/
   proc test2(test: borrowed Test) throws {
     test.skip("Skipping the test directly");
   }

   UnitTest.main();


Output:

.. code-block:: bash

  ======================================================================
  SKIPPED xyz.chpl: test2()
  ----------------------------------------------------------------------
  TestSkipped: Skipping the test directly

  ----------------------------------------------------------------------
  Run 1 test

  OK skipped = 1


Specifying locales
^^^^^^^^^^^^^^^^^^

You can specify the num of locales of a test using these method.

:proc:`~Test.addNumLocales`
:proc:`~Test.maxLocales`
:proc:`~Test.minLocales`

Here is an example demonstrating how to use the :proc:`~Test.addNumLocales`

.. code-block:: chapel

  proc test_square(test: borrowed Test) throws {
    test.addNumLocales(5);
    var A: [Locales.domain] int;
    coforall i in 0..numLocales-1 with (ref A) {
      on Locales(i) {
        A[i+1] = (i+1)*(i+1);
      }
    }
    test.assertTrue(A[5]==25);
  }

Output:

.. code-block:: bash

  ----------------------------------------------------------------------
  Run 1 test

  OK

You can also specify multiple locales on which your code can run.

.. code-block:: chapel

  proc test3(test: borrowed Test) throws {
    test.addNumLocales(16,8);
  }

You can mention the range of locales using :proc:`~Test.maxLocales` and
:proc:`~Test.minLocales`

.. code-block:: chapel

  proc test4(test: borrowed Test) throws {
    test.maxLocales(4);
    test.minLocales(2);
  }

Specifying Dependencies
^^^^^^^^^^^^^^^^^^^^^^^

You can specify the order in which tests should run using :proc:`~Test.dependsOn`:

.. code-block:: chapel

   use UnitTest;

   var factorials: list(int);

   // calculates factorial
   proc factorial(x: int): int {
     return if x == 0 then 1 else x * factorial(x-1);
   }

   proc testFillFact(test: borrowed Test) throws {
     test.skipIf(factorial(0) != 1,"Base condition is wrong in factorial");
     for i in 1..10 do
       factorials.pushBack(factorial(i));
   }

   proc testSumFact(test: borrowed Test) throws {
     test.dependsOn(testFillFact);
     var s = 0;
     for i in factorials.indices do
       s += factorials[i];
     test.assertGreaterThan(s,0);
   }

   UnitTest.main();

Output:

.. code-block:: bash

  ----------------------------------------------------------------------
  Run 2 tests

  OK

*/
module UnitTest {
  use Reflection;
  use Regex;
  use TestError;
  use List, Map;
  private use IO, IO.FormattedIO;

  @chpldoc.nodoc
  config const testNames: string = "None";
  @chpldoc.nodoc
  config const failedTestNames: string = "None";
  @chpldoc.nodoc
  config const errorTestNames: string = "None";
  @chpldoc.nodoc
  config const skippedTestNames: string = "None";
  @chpldoc.nodoc
  config const ranTests: string = "None";
  // This is a dummy test to capture the function signature
  private
  proc testSignature(test: borrowed Test) throws { }
  @chpldoc.nodoc
  var tempFcf = testSignature;
  @chpldoc.nodoc
  type argType = tempFcf.type;  //Type of First Class Test Functions

  class Test {
    @chpldoc.nodoc
    var numMaxLocales = max(int),
        numMinLocales = min(int);
    @chpldoc.nodoc
    var dictDomain: domain(int);
    @chpldoc.nodoc
    var testDependsOn: list(argType);

    /* Unconditionally skip a test.

      :arg reason: the reason for skipping
      :throws TestSkipped: Always

    */
    proc skip(reason: string = "") throws {
      throw new owned TestSkipped(reason);
    }

    /*
    Skip a test if the condition is true.

    :arg condition: the boolean condition

    :arg reason: the reason for skipping
    :throws TestSkipped: If the `condition` is true.
   */
    proc skipIf(condition: bool, reason: string = "") throws {
      if condition then
        skip(reason);
    }

    /*
      Assert that ``test`` is `true`.

      :arg test: the boolean condition
      :throws AssertionError: If the assertion is `false`.
    */
    pragma "insert line file info"
    pragma "always propagate line file info"
    proc assertTrue(test: bool) throws {
      if !test then
        throw new owned AssertionError("assertTrue failed. Given expression is False");
    }

    /*
      Assert that ``test`` is `false`.

      :arg test: the boolean condition
      :throws AssertionError: If the assertion is `true`.
    */
    pragma "insert line file info"
    pragma "always propagate line file info"
    proc assertFalse(test: bool) throws {
      if test then
        throw new owned AssertionError("assertFalse failed. Given expression is True");
    }

    pragma "insert line file info"
    pragma "always propagate line file info"
    @chpldoc.nodoc
    /*Function to call the respective method for equality checking based on the type of argument*/
    proc checkAssertEquality(first, second) throws {
      type firstType = first.type,
          secondType = second.type;

      if isTupleType(firstType) && isTupleType(secondType) {
        // both are tuples.
        assertTupleEqual(first, second);
        return;
      }
      else if isArrayType(firstType) && isArrayType(secondType) {
        // both are arrays
        assertArrayEqual(first, second);
        return;
      }
      else if isRangeType(firstType) && isRangeType(secondType) {
        // both are Range
        assertRangeEqual(first, second);
      }
      else if isString(first) && isString(second) {
        // both are Strings
        assertStringEqual(first, second);
      }
      else {
        __baseAssertEqual(first, second);
      }
    }

    @chpldoc.nodoc
    /*
      Check that a boolean array is true.  If any element is false, returns 'false'
      else return 'true'.

      :arg it: the iterator to the array
      :type it: `iterator`
    */
    proc all(it: _iteratorRecord) {
      for b in it do if b == false then return false;
      return true;
    }

    @chpldoc.nodoc
    /* Method overloading for the above function. Return the argument itself
    */
    proc all(check: bool) {
      return check;
    }

    pragma "insert line file info"
    pragma "always propagate line file info"
    @chpldoc.nodoc
    /*An equality assertion for non-array sequences (like tuples, strings, range).
      Args:
      seq1: The first sequence to compare.
      seq2: The second sequence to compare.
      seq_type_name: The name of datatype of the sequences
    */
    proc assertSequenceEqual(seq1, seq2, seq_type_name) throws {
      var tmpString: string;
      const len1 = seq1.size,
            len2 = seq2.size;
      if len1 == 0 && len2 == 0 then return;
      if len1 == 0 {
        tmpString = "First "+seq_type_name+" has no length.";
      }
      if tmpString == "" {
        if len2 == 0 {
          tmpString = "Second "+seq_type_name+" has no length.";
        }
      }
      if tmpString == "" {
        if len1 == len2 {
          if all(seq1 == seq2) then return;
        }
        var shorterLength = min(len1, len2);
        tmpString = seq_type_name+"s differ: ";
        tmpString += "'%?' != '%?'".format(seq1, seq2);
        for i in 0..#shorterLength {
          if seq1[i] != seq2[i] {
            tmpString += "\nFirst differing element at index %?:\n'%?'\n'%?'\n".format(i, seq1[i], seq2[i]);
            break;
          }
        }
        if len1 > len2 {
          var size_diff = len1 - len2;
          tmpString += "\nFirst %? contains %? additional elements.\n".format(seq_type_name, size_diff);
          tmpString += "First extra element is at index %?\n'%?'\n".format(len2, seq1[len2]);
        }
        else if len1 < len2 {
          var size_diff = len2 - len1;
          tmpString += "\nSecond %? contains %? additional elements.\n".format(seq_type_name, size_diff);
          tmpString += "First extra element is at index %?\n'%?'\n".format(len1, seq2[len1]);
        }
      }
      throw new owned AssertionError(tmpString);
    }

    pragma "insert line file info"
    pragma "always propagate line file info"
    @chpldoc.nodoc
    /*An array-specific equality assertion.
      Args:
      array1: The first array to compare.
      array2: The second array to compare.
    */
    proc assertArrayEqual(array1: [], array2: []) throws {
      const genericErrorMsg = "assert failed -\n'%?'\nand\n'%?'\n".format(array1, array2);

      // Compare array types, size, and shape
      if array1.rank != array2.rank {
        const errorMsg = genericErrorMsg + "are not of same rank";
        throw new owned AssertionError(errorMsg);
      } else if array1.type != array2.type {
        const errorMsg = genericErrorMsg + "are not of same type";
        throw new owned AssertionError(errorMsg);
      } else if array1.size != array2.size {
        const errorMsg = genericErrorMsg + "are not of same size";
        throw new owned AssertionError(errorMsg);
      } else if array1.shape != array2.shape {
        const errorMsg = genericErrorMsg + "are not of same shape";
        throw new owned AssertionError(errorMsg);
      } else {

        // Compare array values
        const arraysEqual = && reduce (array1 == array2);
        if !arraysEqual {
          const errorMsg = "assert failed -\n'%?'\n!=\n'%?'".format(array1, array2);
          throw new owned AssertionError(errorMsg);
        }
      }
    }


    pragma "insert line file info"
    pragma "always propagate line file info"
    @chpldoc.nodoc
    /*
      A tuple-specific equality assertion.
      Args:
      tuple1: The first tuple to compare.
      tuple2: The second tuple to compare.
    */
    proc assertTupleEqual(tuple1, tuple2) throws {
      type firstType = tuple1.type,
          secondType = tuple2.type;
      if firstType == secondType {
        assertSequenceEqual(tuple1,tuple2,"tuple("+firstType: string+")");
      }
      else {
        const errorMsg = "assert failed - '%?' and '%?' are not of same type".format(tuple1, tuple2);
        throw new owned AssertionError(errorMsg);
      }
    }


    pragma "insert line file info"
    pragma "always propagate line file info"
    @chpldoc.nodoc
    /*
      A range-specific equality assertion.
      Args:
      range1: The first range to compare.
      range2: The second range to compare.
    */
    proc assertRangeEqual(range1, range2) throws {
      __baseAssertEqual(range1,range2);
    }

    pragma "insert line file info"
    pragma "always propagate line file info"
    @chpldoc.nodoc
    /*
      A string-specific equality assertion.
      Args:
      string1: The first string to compare.
      string2: The second string to compare.
    */
    proc assertStringEqual(string1, string2) throws {
      assertSequenceEqual(string1,string2,"String");
    }

    pragma "insert line file info"
    pragma "always propagate line file info"
    @chpldoc.nodoc
    /*The default assertEqual implementation, not type specific.*/
    proc __baseAssertEqual(first, second) throws {
      if canResolve("!=",first,second) {
        if (first != second) {
          const errorMsg = "assert failed - '%?' != '%?'".format(first, second);
          throw new owned AssertionError(errorMsg);
        }
      }
      else {
        const errorMsg = "assert failed - '%?' and '%?' are not of same type".format(first, second);
        throw new owned AssertionError(errorMsg);
      }
    }

    /*
      Assert that ``first == second``.

      :arg first: The first object to compare.
      :arg second: The second object to compare.
      :throws AssertionError: If both the arguments are not equal.
    */
    pragma "insert line file info"
    pragma "always propagate line file info"
    proc assertEqual(first, second) throws {
      checkAssertEquality(first, second);
    }

    /*
      Assert that x matches the regular expression pattern.

      .. warning::

        This method requires Chapel to be built with `CHPL_RE2=bundled`.

      :arg x: The first string or bytes to match.
      :arg pattern: The regular expression pattern.
      :throws AssertionError: If x doesn't match the regex
    */
    pragma "insert line file info"
    pragma "always propagate line file info"
    proc assertRegexMatch(x: ?t, pattern: t) throws {
      var re = new regex(pattern);
      checkAssertRegexMatch(x, re);
    }

    /*
      Assert that x matches the pre-compiled regular expression object.

      .. warning::

        This method requires Chapel to be built with `CHPL_RE2=bundled`.

      :arg x: The first string or bytes to match.
      :arg pattern: The pre-compiled regular expression object.
      :throws AssertionError: If x doesn't match the regex
    */
    pragma "insert line file info"
    pragma "always propagate line file info"
    proc assertRegexMatch(x: ?t, re: regex(t)) throws {
      checkAssertRegexMatch(x, re);
    }

    pragma "insert line file info"
    pragma "always propagate line file info"
    @chpldoc.nodoc
    proc checkAssertRegexMatch(x: ?t, re: regex(t)) throws {
      if !re.match(x) {
        const errorMsg = "assert failed - '%?' doesn't match\
                          the regular expression '%?'".format(x, re:t);
        throw new owned AssertionError(errorMsg);
      }
    }

    pragma "insert line file info"
    pragma "always propagate line file info"
    @chpldoc.nodoc
    /* Function that checks whether two arguments are unequal or not*/
    proc checkAssertInequality(first,second) throws {
      type firstType = first.type,
          secondType = second.type;
      if isTupleType(firstType) && isTupleType(secondType) {
        if firstType == secondType {
          if first == second then return false;
        }
      }
      else if isArrayType(firstType) && isArrayType(secondType) {
        if (firstType == secondType) && (first.size == second.size) {
          if first.equals(second) then return false;
        }
      }
      else {
        if first == second then return false;
      }
      return true;
    }


    /*
      Assert that ``first != second``.

      :arg first: The first object to compare.
      :arg second: The second object to compare.
      :throws AssertionError: If both the arguments are equal.
    */
    pragma "insert line file info"
    pragma "always propagate line file info"
    proc assertNotEqual(first, second) throws {
      if canResolve("!=",first, second) {
        if !checkAssertInequality(first,second) {
          const errorMsg = "assert failed -\n'%?'\n==\n'%?'".format(first, second);
          throw new owned AssertionError(errorMsg);
        }
      }
    }

    /*
      Assert that ``first > second``.

      :arg first: The first object to compare.
      :arg second: The second object to compare.
      :throws AssertionError: If the first argument is not greater than second argument.
    */
    pragma "insert line file info"
    pragma "always propagate line file info"
    proc assertGreaterThan(first, second) throws {
      if canResolve(">=",first, second) {
        checkGreater(first, second);
      }
      else {
        const errorMsg = "assert failed - First element is of type %? and Second is of type %?".format(first.type:string, second.type:string);
        throw new owned AssertionError(errorMsg);
      }
    }

    pragma "insert line file info"
    pragma "always propagate line file info"
    @chpldoc.nodoc
    /*checks the type of the arguments and then do greater than comparison */
    proc checkGreater(first, second) throws {
      type firstType = first.type,
          secondType = second.type;

      if isTupleType(firstType) && isTupleType(secondType) {
        // both are tuples.
        assertTupleGreater(first, second);
        return;
      }
      else if isArrayType(firstType) && isArrayType(secondType) {
        // both are arrays
        assertArrayGreater(first, second);
        return;
      }
      else if isRangeType(firstType) && isRangeType(secondType) {
        // both are Range
        assertRangeGreater(first, second);
      }
      else if isString(first) && isString(second) {
        // both are Strings
        assertStringGreater(first, second);
      }
      else {
        __baseAssertGreater(first, second);
      }
    }

    pragma "insert line file info"
    pragma "always propagate line file info"
    @chpldoc.nodoc
    /*An greater assertion for sequences (like arrays, tuples, strings).
      Args:
      seq1: The first sequence to compare.
      seq2: The second sequence to compare.
      seq_type_name: The name of datatype of the sequences
    */
    proc assertSequenceGreater(seq1, seq2, param seq_type_name) throws {
      var checkgreater: bool = false,
          checkequal: bool = false;
      const len1 = seq1.size,
            len2 = seq2.size;
      var symbol: string,
          tmpString: string,
          tmplarge: string;

      if len1 == 0 {
        tmpString = "First "+seq_type_name+" has no length.";
      }
      if tmpString == "" {
        if len2 == 0 {
          tmpString = "Second "+seq_type_name+" has no length.";
        }
      }
      if tmpString == "" {
        for (item1, item2, i) in zip(seq1, seq2, 0..) {
          if item1 == item2 then checkequal = true;
          else if item1 < item2 {
            tmpString += "First %? < Second %? :\n".format(seq_type_name, seq_type_name);
            tmplarge += "\nFirst larger element in second %? is at index %?:\n'%?'\n'%?'\n".format(seq_type_name, i, item1, item2);
            checkgreater = true;
            checkequal = false;
            symbol = "<";
            break;
          }
          else {
            checkequal = false;
            break;
          }
        }
        if !checkgreater && !checkequal then return;
        else if checkequal {
          tmpString += "Both "+seq_type_name+" are equal\n";
          symbol = "==";
        }
        if seq_type_name == "Array" {
          tmpString += "'[";
          for i in seq1.domain {
            tmpString += if i != seq1.size-1
              then "%?, ".format(seq1[i])
              else "%?]'%?'[".format(seq1[i], symbol);
          }
          for i in seq2.domain {
            tmpString += if i != seq2.size-1
              then "%?, ".format(seq2[i])
              else "%?]'".format(seq2[i]);
          }
        }
        else {
          tmpString += "'%?'%?'%?'".format(seq1, symbol, seq2);
        }
        tmpString+=tmplarge;
      }
      throw new owned AssertionError(tmpString);
    }

    pragma "insert line file info"
    pragma "always propagate line file info"
    @chpldoc.nodoc
    /*An array-specific greater assertion.
      Args:
      array1: The first array to compare.
      array2: The second array to compare.
    */
    proc assertArrayGreater(array1, array2) throws {
      if array1.rank == array2.rank {
        if array1.shape == array2.shape {
          if array1.rank == 1 {
            assertSequenceGreater(array1, array2, "Array");
          }
          else { // can be reimplemented using `reduce`
            if all(array1 <= array2) {
              const errorMsg = "assert failed -\n'%?'\n<=\n'%?'".format(array1, array2);
              throw new owned AssertionError(errorMsg);
            }
        }
        }
        else {
          const errorMsg = "assert failed - First element is of shape %? and Second is of shape %?".format(array1.shape, array2.shape);
          throw new owned AssertionError(errorMsg);
        }
      }
      else {
        const errorMsg = "assert failed - First element is of type %? and Second is of type %?".format(array1.type:string, array2.type:string);
        throw new owned AssertionError(errorMsg);
      }
    }

    pragma "insert line file info"
    pragma "always propagate line file info"
    @chpldoc.nodoc
    /*
      A tuple-specific greater assertion.
      Args:
      tuple1: The first tuple to compare.
      tuple2: The second tuple to compare.
    */
    proc assertTupleGreater(tuple1, tuple2) throws {
      type firstType = tuple1.type,
          secondType = tuple2.type;
      if firstType == secondType {
        assertSequenceGreater(tuple1,tuple2,"tuple("+firstType:string+")");
      }
      else {
        const errorMsg = "assert failed - First element is of type %? and Second is of type %?".format(firstType:string, secondType:string);
        throw new owned AssertionError(errorMsg);
      }
    }

    pragma "insert line file info"
    pragma "always propagate line file info"
    @chpldoc.nodoc
    /*
      A range-specific greater assertion.
      Args:
      range1: The first range to compare.
      range2: The second range to compare.
    */
    proc assertRangeGreater(range1, range2) throws {
      if range1.size == range2.size {
        __baseAssertGreater(range1,range2);
      }
      else {
        var tmpString = "assert failed - Ranges are not of same length";
        throw new owned AssertionError(tmpString);
      }
    }

    pragma "insert line file info"
    pragma "always propagate line file info"
    @chpldoc.nodoc
    /*
      A string-specific Greater assertion.
      Args:
      string1: The first string to compare.
      string2: The second string to compare.
    */
    proc assertStringGreater(string1, string2) throws {
      if string1.size == string2.size {
        assertSequenceGreater(string1,string2,"String");
      }
      else {
        var tmpString = "assert failed - Strings are not of same length";
        throw new owned AssertionError(tmpString);
      }
    }

    pragma "insert line file info"
    pragma "always propagate line file info"
     @chpldoc.nodoc
    /*The default assertGreater implementation, not type specific.*/
    proc __baseAssertGreater(first, second) throws {
      if all(first <= second) {
        const errorMsg = "assert failed - '%?' <= '%?'".format(first, second);
        throw new owned AssertionError(errorMsg);
      }
    }

    /*
      Assert that ``first < second``.

      :arg first: The first object to compare.
      :arg second: The second object to compare.
      :throws AssertionError: If the first argument is not less than the second argument.
    */
    pragma "insert line file info"
    pragma "always propagate line file info"
    proc assertLessThan(first, second) throws {
      if canResolve("<=",first, second) {
        checkLessThan(first, second);
      }
      else {
        const errorMsg = "assert failed - First element is of type %? and Second is of type %?".format(first.type:string, second.type:string);
        throw new owned AssertionError(errorMsg);
      }
    }

    pragma "insert line file info"
    pragma "always propagate line file info"
    @chpldoc.nodoc
    /*checks the type of the arguments and then do less than comparison */
    proc checkLessThan(first, second) throws {
      type firstType = first.type,
          secondType = second.type;

      if isTupleType(firstType) && isTupleType(secondType) {
        // both are tuples.
        assertTupleLess(first, second);
        return;
      }
      else if isArrayType(firstType) && isArrayType(secondType) {
        // both are arrays
        assertArrayLess(first, second);
        return;
      }
      else if isRangeType(firstType) && isRangeType(secondType) {
        // both are Range
        assertRangeLess(first, second);
      }
      else if isString(first) && isString(second) {
        // both are Strings
        assertStringLess(first, second);
      }
      else {
        __baseAssertLess(first, second);
      }
    }

    pragma "insert line file info"
    pragma "always propagate line file info"
    @chpldoc.nodoc
    /*An less than assertion for sequences (like arrays, tuples, strings).
      Args:
      seq1: The first sequence to compare.
      seq2: The second sequence to compare.
      seq_type_name: The name of datatype of the sequences
    */
    proc assertSequenceLess(seq1, seq2, param seq_type_name) throws {
      var checkless: bool = false,
          checkequal: bool = false;
      const len1 = seq1.size,
            len2 = seq2.size;
      var symbol: string,
          tmpString: string,
          tmplarge: string;

      if len1 == 0 {
        tmpString = "First "+seq_type_name+" has no length.";
      }
      if tmpString == "" {
        if len2 == 0 {
          tmpString = "Second "+seq_type_name+" has no length.";
        }
      }
      if tmpString == "" {
        for (item1, item2, i) in zip(seq1, seq2, 0..) {
          if item1 == item2 then checkequal = true;
          else if item1 > item2 {
            tmpString += "First %? > Second %? :\n".format(seq_type_name, seq_type_name);
            tmplarge += "\nFirst larger element in first %? is at index %?:\n'%?'\n'%?'\n".format(seq_type_name, i, item1, item2);
            checkless = true;
            checkequal = false;
            symbol = ">";
            break;
          }
          else {
            checkequal = false;
            break;
          }
        }
        if !checkless && !checkequal then return;
        else if checkequal {
          tmpString += "Both "+seq_type_name+" are equal\n";
          symbol = "==";
        }
        if seq_type_name == "Array" {
          tmpString += "'[";
          for i in seq1.domain {
            tmpString += if i != seq1.size-1
              then "%?, ".format(seq1[i])
              else "%?]'%?'[".format(seq1[i], symbol);
          }
          for i in seq2.domain {
            tmpString += if i != seq2.size-1
              then "%?, ".format(seq2[i])
              else "%?]'".format(seq2[i]);
          }
        }
        else {
          tmpString += "'%?'%?'%?'".format(seq1, symbol, seq2);
        }
        tmpString+=tmplarge;
      }
      throw new owned AssertionError(tmpString);
    }

    pragma "insert line file info"
    pragma "always propagate line file info"
    @chpldoc.nodoc
    /*An array-specific less than assertion.
      Args:
      array1: The first array to compare.
      array2: The second array to compare.
    */
    proc assertArrayLess(array1, array2) throws {
      if array1.rank == array2.rank {
        if array1.shape == array2.shape {
          if array1.rank == 1 {
            assertSequenceLess(array1, array2, "Array");
          }
          else {
            if all(array1 >= array2) {
              const errorMsg = "assert failed -\n'%?'\n>=\n'%?'".format(array1, array2);
              throw new owned AssertionError(errorMsg);
            }
          }
        }
        else {
          const errorMsg = "assert failed - First element is of shape %? and Second is of shape %?".format(array1.shape, array2.shape);
          throw new owned AssertionError(errorMsg);
        }
      }
      else {
        const errorMsg = "assert failed - First element is of type %? and Second is of type %?".format(array1.type:string, array2.type:string);
        throw new owned AssertionError(errorMsg);
      }
    }

    pragma "insert line file info"
    pragma "always propagate line file info"
    @chpldoc.nodoc
    /*
      A tuple-specific less than assertion.
      Args:
      tuple1: The first tuple to compare.
      tuple2: The second tuple to compare.
    */
    proc assertTupleLess(tuple1, tuple2) throws {
      type firstType = tuple1.type,
          secondType = tuple2.type;
      if firstType == secondType {
        assertSequenceLess(tuple1,tuple2,"tuple("+firstType:string+")");
      }
      else {
        var tmpString = "assert failed - First element is of type " + firstType:string +" and Second is of type "+secondType:string;
        throw new owned AssertionError(tmpString);
      }
    }

    pragma "insert line file info"
    pragma "always propagate line file info"
    @chpldoc.nodoc
    /*
      A range-specific Less than assertion.
      Args:
      range1: The first range to compare.
      range2: The second range to compare.
    */
    proc assertRangeLess(range1, range2) throws {
      if range1.size == range2.size {
        __baseAssertLess(range1,range2);
      }
      else {
        var tmpString = "assert failed - Ranges are not of same length";
        throw new owned AssertionError(tmpString);
      }
    }

    pragma "insert line file info"
    pragma "always propagate line file info"
    @chpldoc.nodoc
    /*
      A string-specific Less than assertion.
      Args:
      string1: The first string to compare.
      string2: The second string to compare.
    */
    proc assertStringLess(string1, string2) throws {
      if string1.size == string2.size {
        assertSequenceLess(string1,string2,"String");
      }
      else {
        var tmpString = "assert failed - Strings are not of same length";
        throw new owned AssertionError(tmpString);
      }
    }

    pragma "insert line file info"
    pragma "always propagate line file info"
    @chpldoc.nodoc
    /*The default assertGreater implementation, not type specific.*/
    proc __baseAssertLess(first, second) throws {
      if all(first >= second) {
        const errorMsg = "assert failed - '%?'>='%?'".format(first, second);
        throw new owned AssertionError(errorMsg);
      }
    }

    //
    // Locality specification
    //

    /*
      Specify maximum number of locales this test can run on.

      :arg value: Maximum number of locales with which the test can be run.

      :throws UnexpectedLocales: If `value` is less than 1 or `minNumLocales`
    */
    proc maxLocales(value: int) throws {
      this.numMaxLocales = value;
      if this.numMaxLocales < 1 {
        throw new owned UnexpectedLocales("Max Locales is less than 1");
      }
      if this.numMaxLocales < this.numMinLocales {
        throw new owned UnexpectedLocales("Max Locales is less than Min Locales");
      }
      if value < numLocales {
        throw new owned TestIncorrectNumLocales("Required Locales = %?".format(value));
      }
    }

    /*
      Specify minimum number of locales required to run the test.

      :arg value: Minimum number of locales with which the test can be run.

      :throws UnexpectedLocales: If `value` is more than `maxNumLocales`
    */
    proc minLocales(value: int) throws {
      this.numMinLocales = value;
      if this.numMaxLocales < this.numMinLocales {
        throw new owned UnexpectedLocales("Max Locales is less than Min Locales");
      }
      if value > numLocales {
        throw new owned TestIncorrectNumLocales("Required Locales = %?".format(value));
      }
    }

    /*
      Indicate how many locales to run the test on.

      If a test can run on multiple different locale counts, they can be
      specified using multiple arguments. Only one of the locale counts
      specified will be run in testing.

      .. note::

        To run a single test with multiple locale counts, create multiple tests
        where each test requires a specific locale count.

      :arg locales: locale counts

      :throws UnexpectedLocales: If `locales` are already added.

    */
    proc addNumLocales(locales: int ...?n) throws {
      var canRun =  false;
      if this.dictDomain.size > 0 {
        throw new owned UnexpectedLocales("Locales already added.");
      }
      for curLocale in locales {
        this.dictDomain.add(curLocale);
        if curLocale == numLocales {
          canRun = true;
        }
      }
      if !canRun {
        const errorMsg = "Required Locales = {%?}".format(", ".join([i in this.dictDomain] i:string));
        throw new owned TestIncorrectNumLocales(errorMsg);
      }
    }

    /* Adds the tests which must run before this test.

      :arg tests: First class functions
      :throws DependencyFound: If called for the first time in a function.

    */
    proc dependsOn(tests: argType ...?n) throws {
      if testDependsOn.size == 0 {
        for eachSuperTest in tests {
          this.testDependsOn.pushBack(eachSuperTest);
        }
        throw new owned DependencyFound();
      }
    }
  }

  @chpldoc.nodoc
  /*A test result class that can print formatted text results to a stream.*/
  class TextTestResult {
    var separator1 = "="* 70,
        separator2 = "-"* 70;

    proc startTest(test) throws {
      stdout.writeln(test);
    }

    proc addError(test, errMsg) throws {
      stdout.writeln("Flavour: ERROR");
      PrintError(errMsg);
    }

    proc addFailure(test, errMsg) throws {
      stdout.writeln("Flavour: FAIL");
      PrintError(errMsg);
    }

    proc addSuccess(test) throws {
      stdout.writeln("Flavour: OK");
      stdout.writeln(this.separator1);
      stdout.writeln(this.separator2);
    }

    proc addSkip(test, reason) throws {
      stdout.writeln("Flavour: SKIPPED");
      PrintError(reason);
    }

    proc addIncorrectNumLocales(test, reason) throws {
      stdout.writeln("Flavour: IncorrectNumLocales");
      PrintError(reason);
    }

    proc dependencyNotMet(test) throws {
      stdout.writeln("Flavour: Dependence");
      stdout.writeln(this.separator1);
      stdout.writeln(this.separator2);
    }

    proc PrintError(err) throws {
      stdout.writeln(this.separator1);
      stdout.writeln(err);
      stdout.writeln(this.separator2);
    }

  }

  @chpldoc.nodoc
  class TestSuite {
    var testCount = 0;
    var _tests: list(argType);

    // TODO: Get lifetime checking working in this case and remove pragma unsafe.
    // Pragma "unsafe" disables the lifetime checker here.
    pragma "unsafe"
    proc addTest(test) {
      this._tests.pushBack(test);
      this.testCount += 1;
    }

    // TODO: Get lifetime checking working in this case and remove pragma unsafe.
    // Pragma "unsafe" disables the lifetime checker here.
    pragma "unsafe"
    proc addTests(tests) {
      for test in tests do
        this.addTest(test);
    }

    proc this(i: int) ref: argType {
      return this._tests[i];
    }

    iter these() {
      for i in this._tests do
        yield i;
    }
  }

  private proc testNameFromProcedure(f): string {
    var line = f: string;
    assert(line.startsWith("proc") || line.startsWith("wide proc"));
    var parenIndex = line.find("(");
    assert(parenIndex > -1);
    var name = try! line[(5 : byteIndex)..<parenIndex];

    // Adding parentheses to the end makes it easier to detect in stdout.
    return name + "()";
  }

  /*Runs the tests

    Call this as

    .. code-block:: chapel

      UnitTest.main();
  */
  proc main() throws {

    var testStatus: map(string, bool),
        testsFailed: map(string, bool),
        testsErrored: map(string, bool),
        testsLocalFails: map(string, bool),
        testsPassed: map(string, bool),
        testsSkipped: map(string, bool);
    // Assuming 1 global test suite for now
    // Per-module or per-class is possible too
    var testSuite = new TestSuite();
    //Variable for passing to the primitive
    var testObjGather: owned Test = new Test();
    // gather all the tests
    param n = __primitive("gather tests", testObjGather.borrow());

    for param i in 1..n {
      var test_FCF = __primitive("get test by index",i);
      if (test_FCF: string != tempFcf: string) {
        testSuite.addTest(test_FCF);
      }
    }

    for test in testSuite {
      const testName = testNameFromProcedure(test);
      testStatus.addOrReplace(testName, false);
      testsFailed.addOrReplace(testName, false);
      testsErrored.addOrReplace(testName, false);
      testsLocalFails.addOrReplace(testName, false);
      testsPassed.addOrReplace(testName, false);
      testsSkipped.addOrReplace(testName, false);
    }
    if testNames != "None" {
      for test in testNames.split(" ") {
        testsLocalFails.replace(test.strip(), true);
      }
    }
    if failedTestNames != "None" {
      for test in failedTestNames.split(" ") {
        testsFailed.replace(test.strip(), true); // these tests failed or skipped
        testStatus.replace(test.strip(), true);
      }
    }
    if errorTestNames != "None" {
      for test in errorTestNames.split(" ") {
        testsErrored.replace(test.strip(), true); // these tests failed or skipped
        testStatus.replace(test.strip(), true);
      }
    }
    if skippedTestNames != "None" {
      for test in skippedTestNames.split(" ") {
        testsSkipped.replace(test.strip(), true); // these tests failed or skipped
        testStatus.replace(test.strip(), true);
      }
    }
    if ranTests != "None" {
      for test in ranTests.split(" ") {
        testsPassed.replace(test.strip(), true); // these tests failed or skipped
        testStatus.replace(test.strip(), true);
      }
    }

    for test in testSuite {
      const testName = testNameFromProcedure(test);
      if !testStatus[testName] {
        // Create a test object per test
        var checkCircle: list(string);
        var circleFound = false;
        var testObject = new Test();
        runTestMethod(testStatus, testObject, testsFailed, testsErrored, testsSkipped,
                      testsLocalFails, test, checkCircle, circleFound);
      }
    }
  }

  private
  proc runTestMethod(ref testStatus, ref testObject, ref testsFailed, ref testsErrored,
                      ref testsSkipped, ref testsLocalFails, test, ref checkCircle,
                      ref circleFound) throws {
    var testResult = new TextTestResult();
    var testName = testNameFromProcedure(test); //test is a FCF:
    checkCircle.pushBack(testName);
    try {
      testResult.startTest(testName);
      test(testObject);
      testResult.addSuccess(testName);
      testsLocalFails.replace(testName, false);
    }
    // A variety of catch statements will handle errors thrown
    catch e: AssertionError {
      testResult.addFailure(testName, try! "%?".format(e));
      testsFailed.replace(testName, true);
      // print info of the assertion error
    }
    catch e: DependencyFound {
      var allTestsRan = true;
      for superTest in testObject.testDependsOn {
        var superTestName = testNameFromProcedure(superTest);
        var checkCircleCount = checkCircle.count(superTestName);
        // cycle is checked
        if checkCircleCount > 0 {
          testsSkipped.replace(testName, true);
          circleFound = true;
          var failReason = testName + " skipped because circular dependency found";
          testResult.addSkip(testName, failReason);
          testStatus.replace(testName, true);
          return;
        }
        // if super test didn't Error or Failed or skipped
        if !testsErrored[superTestName] &&
           !testsFailed[superTestName] &&
           !testsSkipped[superTestName] {
          // checking if super test ran or not.
          if !testStatus[superTestName] {
            // Create a test object per test
            var superTestObject = new Test();
            // running the super test
            runTestMethod(testStatus, superTestObject, testsFailed, testsErrored,
                          testsSkipped, testsLocalFails, superTest, checkCircle,
                          circleFound);
            var removeSuperTestCount = checkCircle.count(superTestName);
            if removeSuperTestCount > 0 {
              checkCircle.remove(superTestName);
            }
            // if super test failed
            if testsFailed[superTestName] {
              testsSkipped.replace(testName, true);
              var skipReason = testName + " skipped because " + superTestName +" failed";
              testResult.addSkip(testName, skipReason);
              break;
            }
            // if super test failed
            if testsSkipped[superTestName] {
              testsSkipped.replace(testName, true);
              var skipReason = testName + " skipped because " + superTestName +" skipped";
              testResult.addSkip(testName, skipReason);
              break;
            }
            // this superTest has not yet finished.
            if testsLocalFails[superTestName] {
              allTestsRan = false;
            }

            // if Circle Found running the superTests
            if circleFound then break;

            // if superTest error then
            if testsErrored[superTestName] {
              testsSkipped.replace(testName, true);
              var skipReason = testName + " skipped because " + superTestName +" gave an Error";
              testResult.addSkip(testName, skipReason);
              break;
            }
          }
        }
        // super test Errored
        else if testsErrored[superTestName] {
          testsSkipped.replace(testName, true);
          var skipReason = testName + " skipped because " + superTestName +" gave an Error";
          testResult.addSkip(testName, skipReason);
          break;
        }
        // super test Skipped
        else if testsSkipped[superTestName] {
          testsSkipped.replace(testName, true);
          var skipReason = testName + " skipped because " + superTestName +" Skipped";
          testResult.addSkip(testName, skipReason);
          break;
        }
        //super test failed
        else {
          testsSkipped.replace(testName, true);
          var skipReason = testName + " skipped because " + superTestName +" failed";
          testResult.addSkip(testName, skipReason);
        }
      }
      if circleFound {
        testsSkipped.replace(testName, true);
        var skipReason = testName + " skipped because circular dependency found";
        testResult.addSkip(testName, skipReason);
      }
      // Test is not having error or failures or dependency or skipped
      else if !testsErrored[testName] && allTestsRan &&
              !testsFailed[testName] &&
              !testsSkipped[testName] {
        testObject.dictDomain.clear(); // clearing so that we don't get Locales already added
        runTestMethod(testStatus, testObject, testsFailed, testsErrored, testsSkipped,
                      testsLocalFails, test, checkCircle, circleFound);
      }
      else if !testsErrored[testName] && !allTestsRan &&
              !testsFailed[testName] &&
              !testsSkipped[testName] {
        testResult.dependencyNotMet(testName);
      }
    }
    catch e: TestSkipped {
      testResult.addSkip(testName, "TestSkipped: " + e.message());
      testsSkipped.replace(testName, true);
      // Print info on test skipped
    }
    catch e: TestIncorrectNumLocales {
      testResult.addIncorrectNumLocales(testName, "TestIncorrectNumLocales: " + e.message());
      testsLocalFails.replace(testName, true);
    }
    catch e: UnexpectedLocales {
      testResult.addFailure(testName, "UnexpectedLocales: " + e.message());
      testsFailed.replace(testName, true);
    }
    catch e {
      testResult.addError(testName, e.message());
      testsErrored.replace(testName, true);
    }
    testStatus.replace(testName, true);
  }

  @chpldoc.nodoc
  /* These errors are used for implementation purposes (communication between
     the tests and test runner). Not intended for user consumption. */
  module TestError {
    /*
    :class:`TestError` is a base class.
    */
    class TestError: Error {
      var details: string;

      proc init(details: string = "") {
        this.details = details;
      }

      // Message function overridden here
      override proc message() {
        use CTypes, IO.FormattedIO;
        const thrownFileC = __primitive("chpl_lookupFilename",
                                             this.thrownFileId);
        var thrownFileS: string;
        try! thrownFileS = string.createCopyingBuffer(thrownFileC:c_ptrConst(c_char));

        var msg = try! "in %?:%i - %?".format(thrownFileS, this.thrownLine, this.details);
        return msg;
      }
    }

    /*Assertion Error class. Raised when assert Function Failed*/
    class AssertionError: TestError {
      proc init(details: string = "") {
        super.init(details);
      }
    }

    /* TestSkipped Error Class. Raised when a test is skipped.*/
    class TestSkipped: TestError {
      proc init(details: string = "") {
        super.init(details);
      }
    }

    /* DependencyFound Error Class. Raised when a all dependency
      of a test are not met.
    */
    class DependencyFound: TestError {
      proc init(details: string = "") {
        super.init(details);
      }
    }

    /* TestIncorrectNumLocales Error Class. Raised when test is not run with
      expected number of Locales.
    */
    class TestIncorrectNumLocales: TestError {
      proc init(details: string = "") {
        super.init(details);
      }
    }

    /* UnexpectedLocales Error Class. Raised when test has
        locales with which it can't be run.
        Eg: MaxLocales < MinLocales
    */
    class UnexpectedLocales: TestError {
      proc init(details: string = "") {
        super.init(details);
      }
    }
  }
}
