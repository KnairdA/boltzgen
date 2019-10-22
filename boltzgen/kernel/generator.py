import sympy

from mako.template import Template
from pathlib import Path

class Generator:
    def __init__(self, descriptor, moments, collision, boundary = ''):
        self.descriptor = descriptor
        self.moments    = moments
        self.collision  = collision
        self.boundary   = boundary

    def kernel(self, target, precision, geometry):
        return Template(filename = str(Path(__file__).parent/('template/basic.' + target + '.mako'))).render(
            descriptor = self.descriptor,
            geometry   = geometry,

            moments_subexpr    = self.moments[0],
            moments_assignment = self.moments[1],

            collision_subexpr    = self.collision[0],
            collision_assignment = self.collision[1],

            float_type = precision,

            boundary_src = Template(self.boundary).render(
                descriptor = self.descriptor,
                geometry   = geometry,
                float_type = precision
            ),

            ccode = sympy.ccode
        )
