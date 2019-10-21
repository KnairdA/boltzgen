from sympy import *

# copy of `sympy.integrals.quadrature.gauss_hermite` sans evaluation
def gauss_hermite(n):
    x = Dummy("x")
    p  = hermite_poly(n, x, polys=True)
    p1 = hermite_poly(n-1, x, polys=True)
    xi = []
    w  = []
    for r in p.real_roots():
        xi.append(r)
        w.append(((2**(n-1) * factorial(n) * sqrt(pi))/(n**2 * p1.subs(x, r)**2)))
    return xi, w

# determine weights of a d-dimensional LBM model on velocity set c
# (only works for velocity sets that result into NSE-recovering LB models when
#  plugged into Gauss-Hermite quadrature without any additional arguments
#  i.e. D2Q9 and D3Q27 but not D3Q19)
def weights(d, c):
    _, omegas = gauss_hermite(3)
    return list(map(lambda c_i: Mul(*[ omegas[1+c_i[iDim]] for iDim in range(0,d) ]) / pi**(d/2), c))

# determine lattice speed of sound using directions and their weights
def c_s(d, c, w):
    speeds = set([ sqrt(sum([ w[i] * c_i[j]**2 for i, c_i in enumerate(c) ])) for j in range(0,d) ])
    assert len(speeds) == 1 # verify isotropy
    return speeds.pop()
