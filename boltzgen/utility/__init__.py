from . import optimizations
from . import ndindex
from . import printer

from sympy.codegen.ast import Assignment

def assign(names, definitions):
    return list(map(lambda x: Assignment(*x), zip(names, definitions)))
