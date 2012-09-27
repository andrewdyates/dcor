import dcor_py
import numpy as np

# Sanity test for numpy implementation
a = [1,2,3,4,5]
b = np.array([1,2,9,4,4])
print dcor_py.dcov_all(a,b)
print dcor_py.dcov_all(b,a)
print dcor_py.dcov_all(a,a)

# Sanity test for cython implementation
try:
  import dcor_cpy
  print dcor_cpy.dcov_all(a,b)
  print dcor_cpy.dcov_all(b,a)
  print dcor_cpy.dcov_all(a,a)
except ImportError, e:
  print "Cannot import cython implementation.", e
