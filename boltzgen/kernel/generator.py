import sympy

from mako.template import Template
from pathlib import Path

import kernel.target.cl
import kernel.target.cpp

class Generator:
    def __init__(self, descriptor, moments, collision, boundary = ''):
        self.descriptor = descriptor
        self.moments    = moments
        self.collision  = collision
        self.boundary   = boundary

    def kernel(self, target, precision, layout, geometry):
        template_path = Path(__file__).parent/('template/basic.' + target + '.mako')
        if not template_path.exists():
            raise Exception("Target '%s' not supported" % target)

        layout_impl = eval("kernel.target.%s.%s" % (target, layout))
        if layout_impl is None:
            raise Exception("Target '%s' doesn't support layout '%s'" % (target, layout))
        else:
            layout_impl = layout_impl(self.descriptor, geometry)

        return Template(filename = str(template_path)).render(
            descriptor = self.descriptor,
            geometry   = geometry,
            layout     = layout_impl,

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
