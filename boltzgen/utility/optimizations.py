from sympy import *

from sympy.codegen.rewriting import ReplaceOptim

expand_square = ReplaceOptim(
    lambda e: e.is_Pow and e.exp.is_integer and e.exp == 2,
    lambda p: UnevaluatedExpr(Mul(p.base, p.base, evaluate = False))
)

custom = [ (expand_square, expand_square) ] + cse_main.basic_optimizations
