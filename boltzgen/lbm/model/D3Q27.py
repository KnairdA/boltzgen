from sympy import Matrix
from itertools import product

d = 3
q = 27

c = [ Matrix(x) for x in product([-1,0,1], repeat=d) ]
