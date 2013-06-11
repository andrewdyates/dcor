dcor
====

Compute distance correlation.

Includes both a native Python and a Cython implementation. By default,
the module uses the cython implementation, but this can be changed by
setting the `DCOR_IMPLEMENTATION` global variable to 'py' before
importing this module. Alternatively, one could also directly import
the preferred implementation as it's included in this module.

Cython modules require complication per computer. See
"setup_cython.py" for compilation instructions.

Included .so binary compiled to run on the osc.edu Oakley super
computer cluster. Compiling on a new platform may overwrite this file;
be careful on committing to the master branch in this case!

----
To build on local machine:

0) Install cython if it is not already installed.
$ easy_install cython

1) Remove compiled copy if it exists. (in 'dcor' package directory)
$ rm dcor_cpy.so dcor_cpy.c

2) Compile dcor_cpy.pyx file
$ python setup_cython.py build_ext --inplace

3) Confirm operation in python
$ python test.py

