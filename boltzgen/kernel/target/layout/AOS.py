class AOS:
    def __init__(self, descriptor, cell_index, geometry):
        self.descriptor = descriptor
        self.cell_index = cell_index
        self.geometry = geometry

    def cell_preshift(self, gid):
        return "(%s)*%d" % (gid, self.descriptor.q)

    def pop_offset(self, i):
        return i

    def neighbor_offset(self, c_i):
        return self.descriptor.q * self.cell_index.neighbor(c_i)
