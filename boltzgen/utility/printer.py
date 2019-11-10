from sympy.printing.ccode import C99CodePrinter
from sympy.codegen.ast import float32, float64

class CudaCodePrinter(C99CodePrinter):
    pass

    def __init__(self, float_type, **args):
        super(CudaCodePrinter, self).__init__(**args)
        if float_type == 'float':
            self.type_func_suffixes[float32]    = 'f'
            self.type_func_suffixes[float64]    = 'f'
            self.type_literal_suffixes[float32] = 'f'
            self.type_literal_suffixes[float64] = 'f'
