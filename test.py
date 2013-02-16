import dcor_py
import numpy as np

# Sanity test for numpy implementation
a = [1,2,3,4,5]
b = np.array([1,2,9,4,4])
print "a: ", a
print "b: ", b
print "(dcov, dcor, a_dcov, b_dcor)"
print "R energy package expected values"
print "1.1593101 0.7626762 1.1027239 2.0953281"
print "Numpy Implementation"
print dcor_py.dcov_all(a,b)
print dcor_py.dcov_all(b,a)
print dcor_py.dcov_all(a,a)

# Sanity test for cython implementation
try:
  import dcor_cpy
  print "Cython Implementation"
  print dcor_cpy.dcov_all(a,b)
  print dcor_cpy.dcov_all(b,a)
  print dcor_cpy.dcov_all(a,a)
except ImportError, e:
  print "DID YOU BUILD CYTHON FOR YOUR PLATFORM? SEE README!"
  print
  print "Cannot import cython implementation.", e
