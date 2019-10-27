class SOA:
    def __init__(self, descriptor, geometry):
        self.descriptor = descriptor
        self.geometry = geometry

    def gid(self):
        return {
            2: 'get_global_id(1)*%d + get_global_id(0)' % self.geometry.size_x,
            3: 'get_global_id(2)*%d + get_global_id(1)*%d + get_global_id(0)' % (self.geometry.size_x*self.geometry.size_y, self.geometry.size_x)
        }.get(self.descriptor.d)

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

    def gid(self):
        return {
            2: '%d*(get_global_id(1)*%d + get_global_id(0))' % (self.descriptor.q, self.geometry.size_x),
            3: '%d*(get_global_id(2)*%d + get_global_id(1)*%d + get_global_id(0))' % (self.descriptor.q, self.geometry.size_x*self.geometry.size_y, self.geometry.size_x)
        }.get(self.descriptor.d)

    def pop_offset(self, i):
        return i

    def neighbor_offset(self, c_i):
        return self.descriptor.q * {
            2: lambda:                                                    c_i[1]*self.geometry.size_x + c_i[0],
            3: lambda: c_i[2]*self.geometry.size_x*self.geometry.size_y + c_i[1]*self.geometry.size_x + c_i[0]
        }.get(self.descriptor.d)()
