.. _readme-main:

=======================
The ``main()`` Function
=======================

After running module initialization code (top-level statements in
modules), a Chapel program will start executing from the entry point,
a function named ``main()``.  Chapel's main function has typically
taken no arguments and had no return type.  This technote describes
initial support for returning a status value and making ``main()`` take
arbitrary command-line arguments.

Returning a Status Value
========================

Traditionally, the only way to return a nonzero exit value from a
Chapel program has been to call ``exit()``.  Optionally,
``main()`` can be declared to return an integer in which case the value
returned serves as the status value.

.. _technote-mainWithArgs:

Having ``main()`` Accept Command-line Arguments
===============================================

Overview
--------

Because Chapel programs have traditionally accepted a number of
"built-in" flags and configuration variables, there has been no way to
create a Chapel program that accepts arguments like an arbitrary list
of filenames or flags that might conflict with built-in capabilities.
For most uses, Chapel's existing config variable support is useful and
easy; occasionally, however, one wants to fully control argument
processing.

If a program's main function is declared to take no arguments, Chapel
will behave as it traditionally has: built-in flags and config
settings will be handled and unrecognized flags will trigger an error.

Alternatively, ``main()`` can be declared to take an array of
strings as an argument. By doing so, the program opts-in to explicit
argument handling, described in the remainder of this technote.

Usage
-----

To use this feature, declare ``main()`` as follows:

.. literalinclude:: ../../../test/technotes/doc-examples/MainProcExample0.chpl
   :language: chapel
   :start-after: START_EXAMPLE_0
   :end-before: STOP_EXAMPLE_0

When ``main()`` is so declared, Chapel's default command line argument
processing changes. Rather than generate an error message when an
unknown argument is encountered, that argument will instead be passed
on to this ``main(args)`` function. Arguments corresponding to config
variables or Chapel's predefined flags (like ``-nl``, etc.) will still
be processed and will not be passed on to the ``main(args)`` function.

To be clear, the arguments that would be handled without using this
feature will continue to behave as usual. The difference is that other
arguments will be passed to ``main(args)`` rather than generating an
error message. The only exception to this, is ``--help`` and ``-h``.

Prior to this feature, a Chapel program would always exit immediately
after printing the help message. A programmer might want to print
other information explaining what non-config-var command line
arguments are available and what they might do. For this reason, when
a Chapel program includes a ``main()`` declared to take arguments,
``--help`` and ``-h`` will be passed on to the ``main(args)`` function.

The function :chpl:proc:`Help.printUsage()` will print out the familiar
config var table. To gain access to this new function requires a module:

.. literalinclude:: ../../../test/technotes/doc-examples/MainProcExample0.chpl
   :language: chapel
   :start-after: START_EXAMPLE_1
   :end-before: STOP_EXAMPLE_1

The following program scans its argument list for ``--help``, and if
found, it prints the standard usage message as well as some additional text
explaining the purpose of the extra arguments. Note that this could be
used by a program which simply wants to add explanatory text to the
``--help`` output without actually handling any additional arguments.

.. literalinclude:: ../../../test/technotes/doc-examples/MainProcExample1.chpl
   :language: chapel
   :start-after: START_EXAMPLE_0
   :end-before: STOP_EXAMPLE_0

There is a way to suspend argument processing when ``main()`` is declared
to take arguments.

Suppose that you need to pass a file named ``--myFlag=true`` to the
program written above. If passed like normal, then the Chapel runtime
will consume this argument at startup and use it to set the associated
config var named ``myFlag``.

However, if the argument ``--`` is placed in the argument list, all
subsequent arguments will be passed through to ``main()`` without
being processed by the Chapel runtime.

The scenario described could be invoked on the shell like so:

.. code-block:: shell

  ./myprogram --help -- --myFlag=true

This will result in ``--myFlag=true`` being output by ``myprogram`` as
an additional file name.
