import numpy
from numpy.lib.stride_tricks import as_strided
import numpy.core.numeric as _nx

class ndindex(numpy.ndindex):
    pass

    def __init__(self, *shape, order='F'):
        if len(shape) == 1 and isinstance(shape[0], tuple):
            shape = shape[0]
        x = as_strided(_nx.zeros(1), shape=shape,
                       strides=_nx.zeros_like(shape))
        self._it = _nx.nditer(x, flags=['multi_index', 'zerosize_ok'],
                              order=order)
