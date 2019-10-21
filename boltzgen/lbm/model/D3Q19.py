from sympy import Matrix, Rational, sqrt

d = 3
q = 19

c = [ Matrix(x) for x in [
    ( 0, 1, 1), (-1, 0, 1), ( 0, 0, 1), ( 1, 0, 1), ( 0, -1, 1),
    (-1, 1, 0), ( 0, 1, 0), ( 1, 1, 0), (-1, 0, 0), ( 0, 0, 0), ( 1, 0, 0), (-1,-1, 0), ( 0, -1, 0), ( 1, -1, 0),
    ( 0, 1,-1), (-1, 0,-1), ( 0, 0,-1), ( 1, 0,-1), ( 0, -1,-1)
]]

w = [Rational(*x) for x in [
    (1,36), (1,36), (1,18), (1,36), (1,36),
    (1,36), (1,18), (1,36), (1,18), (1,3), (1,18), (1,36), (1,18), (1,36),
    (1,36), (1,36), (1,18), (1,36), (1,36)
]]

c_s = sqrt(Rational(1,3))
