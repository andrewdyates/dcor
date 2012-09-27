#!/usr/bin/python
"""Compile using:

python setup_cython.py build_ext --inplace
"""
from distutils.core import setup
from distutils.extension import Extension
from Cython.Distutils import build_ext

import numpy

ext = Extension("dcor_cpy", ["dcor_cpy.pyx"],
    include_dirs = [numpy.get_include()])
                
setup(ext_modules=[ext],
      cmdclass = {'build_ext': build_ext})

