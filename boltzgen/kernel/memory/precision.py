class common:
    @classmethod
    def get_float_type(self, precision):
        if precision not in ['single', 'double']:
            raise Exception("Precision must be either 'single' or 'double'")

        return {
            'single': 'float',
            'double': 'double'
        }.get(precision)

class cpp(common):
    pass

class cl(common):
    pass

class cuda(common):
    pass
