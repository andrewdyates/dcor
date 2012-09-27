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
