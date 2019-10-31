from sympy import *
from sympy.codegen.ast import Assignment

import boltzgen.utility.optimizations as optimizations
from boltzgen.lbm.model.characteristics import weights, c_s


def assign(names, definitions):
    return list(map(lambda x: Assignment(*x), zip(names, definitions)))

class LBM:
    def __init__(self, descriptor, tau, optimize = True):
        self.descriptor = descriptor
        self.tau        = tau
        self.optimize   = optimize

        if self.tau <= 0.5:
            raise Exception('Relaxation time must be larger than 0.5')

        self.f_next = symarray('f_next', descriptor.q)
        self.f_curr = symarray('f_curr', descriptor.q)

        if not hasattr(descriptor, 'w'):
            self.descriptor.w = weights(descriptor.d, descriptor.c)

        if not hasattr(descriptor, 'c_s'):
            self.descriptor.c_s = c_s(descriptor.d, descriptor.c, self.descriptor.w)

    def moments(self, optimize = None):
        if optimize is None:
            optimize = self.optimize

        rho = symbols('rho')
        u   = Matrix(symarray('u', self.descriptor.d))

        exprs = [ Assignment(rho, sum(self.f_curr)) ]

        for i, u_i in enumerate(u):
            exprs.append(
                Assignment(u_i, sum([ (c_j*self.f_curr[j])[i] for j, c_j in enumerate(self.descriptor.c) ]) / sum(self.f_curr)))

        if optimize:
            return cse(exprs, optimizations=optimizations.custom, symbols=numbered_symbols(prefix='m'))
        else:
            return ([], exprs)

    def equilibrium(self, resolve_moments = False):
        rho = symbols('rho')
        u   = Matrix(symarray('u', self.descriptor.d))

        if resolve_moments:
            moments = self.moments(optimize = False)[1]
            rho = moments[0].rhs
            for i, m in enumerate(moments[1:]):
                u[i] = m.rhs

        f_eq = []

        for i, c_i in enumerate(self.descriptor.c):
            f_eq_i = self.descriptor.w[i] * rho * ( 1
                                                  + c_i.dot(u)    /    self.descriptor.c_s**2
                                                  + c_i.dot(u)**2 / (2*self.descriptor.c_s**4)
                                                  - u.dot(u)      / (2*self.descriptor.c_s**2) )
            f_eq.append(f_eq_i)

        return f_eq

    def bgk(self, f_eq, optimize = None):
        if optimize is None:
            optimize = self.optimize

        exprs = [ self.f_curr[i] + 1/self.tau * (f_eq_i - self.f_curr[i]) for i, f_eq_i in enumerate(f_eq) ]

        if optimize:
            subexprs, f = cse(exprs, optimizations=optimizations.custom)
            return (subexprs, assign(self.f_next, f))
        else:
            return ([], assign(self.f_next, exprs))
