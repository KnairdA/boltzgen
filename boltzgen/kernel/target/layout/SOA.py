class SOA:
    def __init__(self, descriptor, index, geometry):
        self.descriptor = descriptor
        self.index    = index(geometry)
        self.geometry = geometry

    def cell_preshift(self, gid):
        return gid

    def pop_offset(self, i):
        return i * self.geometry.volume

    def neighbor_offset(self, c_i):
        return self.index.neighbor(c_i)
