from sympy import Matrix
from itertools import product

d = 2
q = 9

c = [ Matrix(x) for x in product([-1,0,1], repeat=d) ]
