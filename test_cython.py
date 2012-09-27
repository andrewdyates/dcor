# Sanity test for cython implementation
import dcor_cpy
print dcor_cpy.dcov_all(a,b)
print dcor_cpy.dcov_all(b,a)
print dcor_cpy.dcov_all(a,a)
