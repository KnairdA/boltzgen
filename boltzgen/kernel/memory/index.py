class CellIndex:
    def __init__(self, geometry):
        self.geometry   = geometry

    def neighbor(self, c_i):
        return self.gid(*[ c for _, c in enumerate(c_i) ])

class XYZ(CellIndex):
    pass

    def gid(self, x, y, z=0):
        if any(map(lambda v: isinstance(v, str), [x,y,z])):
            return "(%s)*%d + (%s)*%d + %s" % (x, self.geometry.size_y*self.geometry.size_z, y, self.geometry.size_z, z)
        else:
            return x*self.geometry.size_y*self.geometry.size_z + y*self.geometry.size_z + z

class ZYX(CellIndex):
    pass

    def gid(self, x, y, z=0):
        if any(map(lambda v: isinstance(v, str), [x,y,z])):
            return "(%s)*%d + (%s)*%d + %s" % (z, self.geometry.size_x*self.geometry.size_y, y, self.geometry.size_x, x)
        else:
            return z*self.geometry.size_x*self.geometry.size_y + y*self.geometry.size_x + x
