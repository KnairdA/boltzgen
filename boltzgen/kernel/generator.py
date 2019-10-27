import sympy

from mako.template import Template
from pathlib import Path

import kernel.target.cl
import kernel.target.cpp

class Generator:
    def __init__(self, descriptor, moments, collision):
        self.descriptor = descriptor
        self.moments    = moments
        self.collision  = collision

    def instantiate(self, target, template, float_type, layout_impl, geometry, extras = []):
        template_path = Path(__file__).parent/("template/%s.%s.mako" % (template, target))
        if not template_path.exists():
            raise Exception("Target '%s' doesn't provide '%s'" % (target, template))

        return Template(filename = str(template_path)).render(
            descriptor = self.descriptor,
            geometry   = geometry,
            layout     = layout_impl,

            moments_subexpr    = self.moments[0],
            moments_assignment = self.moments[1],
            collision_subexpr    = self.collision[0],
            collision_assignment = self.collision[1],
            ccode = sympy.ccode,

            float_type = float_type,

            extras = extras
        )

    def kernel(self, target, precision, layout, geometry, functions = ['collide_and_stream'], extras = []):
        layout_impl = eval("kernel.target.%s.%s" % (target, layout))
        if layout_impl is None:
            raise Exception("Target '%s' doesn't support layout '%s'" % (target, layout))
        else:
            layout_impl = layout_impl(self.descriptor, geometry)

        if geometry.dimension() != self.descriptor.d:
            raise Exception('Geometry dimension must match descriptor dimension')

        float_type = {
            'single': 'float',
            'double': 'double'
        }.get(precision)

        return "\n".join(map(lambda f: self.instantiate(target, f, float_type, layout_impl, geometry, extras), functions))
