import re
from .utility.ndindex import ndindex

class Geometry:
    def __init__(self, size_x, size_y, size_z = 1):
        self.size_x = size_x
        self.size_y = size_y
        self.size_z = size_z
        self.volume = size_x * size_y * size_z

    @classmethod
    def parse(self, s):
        args = re.search(r'([0-9]+):([0-9]+):?([0-9]+)?', s)
        if args.group(3) == None:
            return self(int(args.group(1)), int(args.group(2)))
        else:
            return self(int(args.group(1)), int(args.group(2)), int(args.group(3)))

    def dimension(self):
        if self.size_x > 1 and self.size_y > 1 and self.size_z == 1:
            return 2
        elif self.size_x > 1 and self.size_y > 1 and self.size_z > 1:
            return 3
        else:
            raise Exception('Geometry malformed')

    def inner_cells(self):
        for idx in numpy.ndindex(self.inner_size()):
            yield tuple(map(lambda i: i + 1, idx))

    def size(self):
        if self.size_z == 1:
            return (self.size_x, self.size_y)
        else:
            return (self.size_x, self.size_y, self.size_z)

    def inner_size(self):
        if self.size_z == 1:
            return (self.size_x-2, self.size_y-2)
        else:
            return (self.size_x-2, self.size_y-2, self.size_z-2)
