class AOS:
    def __init__(self, descriptor, geometry):
        self.descriptor = descriptor
        self.geometry = geometry

    def gid_offset(self):
        return self.descriptor.q

    def pop_offset(self, i):
        return i

    def neighbor_offset(self, c_i):
        return self.descriptor.q * {
            2: lambda:                                                    c_i[0]*self.geometry.size_y + c_i[1],
            3: lambda: c_i[0]*self.geometry.size_y*self.geometry.size_z + c_i[1]*self.geometry.size_z + c_i[2]
        }.get(self.descriptor.d)()

    def padding(self):
        return self.descriptor.q * {
            2: lambda:                                               1*self.geometry.size_y + 1,
            3: lambda: 1*self.geometry.size_y*self.geometry.size_z + 1*self.geometry.size_z + 1
        }.get(self.descriptor.d)()

class SOA:
    def __init__(self, descriptor, geometry):
        self.descriptor = descriptor
        self.geometry = geometry

    def gid_offset(self):
        return 1

    def pop_offset(self, i):
        return i * self.geometry.volume

    def neighbor_offset(self, c_i):
        return {
            2: lambda:                                                    c_i[0]*self.geometry.size_y + c_i[1],
            3: lambda: c_i[0]*self.geometry.size_y*self.geometry.size_z + c_i[1]*self.geometry.size_z + c_i[2]
        }.get(self.descriptor.d)()

    def padding(self):
        return {
            2: lambda:                                               1*self.geometry.size_y + 1,
            3: lambda: 1*self.geometry.size_y*self.geometry.size_z + 1*self.geometry.size_z + 1
        }.get(self.descriptor.d)()
