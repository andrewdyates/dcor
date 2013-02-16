# Copyright (c) 2012, Florian Finkernagel. All right reserved.
## Redistribution and use in source and binary forms, with or without
## modification, are permitted provided that the following conditions are
## met:

##     * Redistributions of source code must retain the above copyright
##       notice, this list of conditions and the following disclaimer.

##     * Redistributions in binary form must reproduce the above
##       copyright notice, this list of conditions and the following
##       disclaimer in the documentation and/or other materials provided
##       with the distribution.

##     * Neither the name of Florian Finkernagel nor the names of its
##       contributors may be used to endorse or promote products derived
##       from this software without specific prior written permission.

## THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
## "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
## LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
## A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
## OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
## SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
## LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
## DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
## THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
## (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
## OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 
"""An implementation of Distance Correlation (see http://en.wikipedia.org/wiki/Distance_correlation )
that is not quadratic in space requirements (only in runtime).


For vectors of length 1000, this is about 40% faster.

%timeit py.dcov_all(A,B)
10 loops, best of 3: 52.1 ms per loop
%timeit cy.dcov_all(A,B)
10 loops, best of 3: 31.5 ms per loop

HOWEVER: it does not handle missing values which must be handled prior to passing
vectors to this function.

AY Feb 2013: Updated to return square root.
"""
DCOR_LIB = "cython"


import numpy as np
cimport numpy as np
import cython


ctypedef np.double_t DTYPE_t

#purely for speed reasons
cdef inline double myabs(double a) : return a if a >= 0. else -1 * a

def dcov_all(x, y):
    'Calculate distance covariance, distance correlation, distance variance of x sample and distance variance of y sample'
    x = np.array(x, dtype=np.double)
    y = np.array(y, dtype=np.double)
    dnx = D_N(x)
    dny = D_N(y)

    denom = float(dnx.dim * dnx.dim)
    dc = np.sqrt(dnx.product_sum(dny) / denom)
    dvx = np.sqrt(dnx.squared_sum() / denom)
    dvy = np.sqrt(dny.squared_sum() / denom)
    dr = dc / (np.sqrt(dvx) * np.sqrt(dvy))
    return dc, dr, dvx, dvy


class D_N: 
    """Inner helper of dcov_all. Cache different means that are required for calculating 
    the matrix members on the fly"""

    def __init__(self, x):
        self.x = np.array(x)
        self.dim = x.shape[0]
        self.calculate_means()

    @cython.boundscheck(False)
    def calculate_means(self):
        cdef int dim = self.dim
        cdef DTYPE_t value
        cdef DTYPE_t sum_total = 0
        cdef np.ndarray[DTYPE_t, ndim=1] sum_0 = np.zeros(dim, dtype=np.double)
        cdef np.ndarray[DTYPE_t, ndim=1] sum_1 = np.zeros(dim, dtype=np.double)
        cdef np.ndarray[DTYPE_t, ndim=1] x = self.x
        cdef unsigned int ii
        cdef unsigned int jj
        for ii in range(dim):
            for jj in range(dim):
                value = myabs(x[jj] - x[ii])
                sum_total += value
                sum_1[jj] += value
                sum_0[ii] += value
        self.mean = sum_total / (self.dim**2)
        self.mean_0 = sum_0 / (self.dim)
        self.mean_1 = sum_1 / (self.dim)
        return

    @cython.boundscheck(False)
    def squared_sum(self):
        cdef np.ndarray[DTYPE_t, ndim=1] mean_0 = self.mean_0
        cdef np.ndarray[DTYPE_t, ndim=1] mean_1 = self.mean_1
        cdef DTYPE_t mean = self.mean
        cdef DTYPE_t squared_sum = 0
        cdef DTYPE_t dist
        cdef DTYPE_t d
        cdef np.ndarray[DTYPE_t, ndim=1] x = self.x
        cdef unsigned int dim = self.dim
        cdef unsigned int ii
        cdef unsigned int jj
        for ii in range(dim):
            for jj in range(dim): 
                dist = myabs(x[jj] - x[ii])
                d = dist - mean_0[ii] - mean_1[jj] + mean
                squared_sum += d * d
        return squared_sum
   
    @cython.boundscheck(False)
    def product_sum(self, other):
        cdef np.ndarray[DTYPE_t, ndim=1] mean_0_here = self.mean_0
        cdef np.ndarray[DTYPE_t, ndim=1] mean_1_here = self.mean_1
        cdef DTYPE_t mean_here = self.mean
        cdef np.ndarray[DTYPE_t, ndim=1] mean_0_there = other.mean_0
        cdef np.ndarray[DTYPE_t, ndim=1] mean_1_there = other.mean_1
        cdef DTYPE_t mean_there = other.mean
        cdef DTYPE_t d_here
        cdef DTYPE_t d_there
        cdef DTYPE_t product_sum = 0
        cdef np.ndarray[DTYPE_t, ndim=1] x = self.x
        cdef np.ndarray[DTYPE_t, ndim=1] y = other.x

        cdef unsigned int dim = self.dim
        cdef unsigned int ii
        cdef unsigned int jj
        for ii in range(dim):
            for jj in range(dim): 
                d_here = myabs(x[jj] - x[ii]) - mean_0_here[ii] - mean_1_here[jj] + mean_here
                d_there = myabs(y[jj] - y[ii]) - mean_0_there[ii] - mean_1_there[jj] + mean_there
                product_sum += d_here * d_there
        return product_sum
