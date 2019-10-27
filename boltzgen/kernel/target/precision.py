class cpp:
    @classmethod
    def get_float_type(self, precision):
        return {
            'single': 'float',
            'double': 'double'
        }.get(precision)

class cl:
    @classmethod
    def get_float_type(self, precision):
        return {
            'single': 'float',
            'double': 'double'
        }.get(precision)
