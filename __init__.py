#!/usr/bin/python
"""Compute distance correlation, supports multiple implementations.

USE:
from dcor import *
dc, dr, dvx, dvy = dcov_all(x,y)

---
dc: distance covariance (not normalized by marginal distributions)
dr: distance correlation
dvx: marginal distance variance, x
dvy: marginal distance variance, y

"""
try:
  DCOR_IMPLEMENTATION
except NameError:
  DCOR_IMPLEMENTATION = "cpy"

if DCOR_IMPLEMENTATION == "cpy":
  # 1. Cython implementation (faster, but has dependencies)
  try:
    from dcor_cpy import *
  # Handle exception in case of cython import errors in pychecker, for example.
  except ImportError, e:
    print "Loading numpy implementation due to import error."
    print e
    from dcor_py import *
elif DCOR_IMPLEMENTATION == "py":
  # 2. Simple, 1D, numpy python implementation
  from dcor_py import *
else:
  from dcor_py import *
