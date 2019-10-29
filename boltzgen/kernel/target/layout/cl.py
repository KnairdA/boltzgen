class SOA:
    def __init__(self, descriptor, geometry):
        self.descriptor = descriptor
        self.geometry = geometry

    def cell_preshift(self, gid):
        return gid

    def pop_offset(self, i):
        return i * self.geometry.volume

    def neighbor_offset(self, c_i):
        return {
            2: lambda:                                                    c_i[1]*self.geometry.size_x + c_i[0],
            3: lambda: c_i[2]*self.geometry.size_x*self.geometry.size_y + c_i[1]*self.geometry.size_x + c_i[0]
        }.get(self.descriptor.d)()

class AOS:
    def __init__(self, descriptor, geometry):
        self.descriptor = descriptor
        self.geometry = geometry

    def cell_preshift(self, gid):
        return "(%s)*%d" % (gid, self.descriptor.q)

    def pop_offset(self, i):
        return i

    def neighbor_offset(self, c_i):
        return self.descriptor.q * {
            2: lambda:                                                    c_i[1]*self.geometry.size_x + c_i[0],
            3: lambda: c_i[2]*self.geometry.size_x*self.geometry.size_y + c_i[1]*self.geometry.size_x + c_i[0]
        }.get(self.descriptor.d)()
