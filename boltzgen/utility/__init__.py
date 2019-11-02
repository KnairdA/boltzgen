from . import optimizations
from . import ndindex

from sympy.codegen.ast import Assignment

def assign(names, definitions):
    return list(map(lambda x: Assignment(*x), zip(names, definitions)))
