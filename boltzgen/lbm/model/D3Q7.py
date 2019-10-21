from sympy import *

q = 7
d = 3

c = [ Matrix(x) for x in [
    ( 0, 0, 1),
    ( 0, 1, 0), (-1, 0, 0), ( 0, 0, 0), ( 1, 0, 0), ( 0, -1, 0),
    ( 0, 0,-1)
]]

w = [Rational(*x) for x in [
    (1,8),
    (1,8), (1,8), (1,4), (1,8), (1,8),
    (1,8)
]]

c_s = sqrt(Rational(1,4))
