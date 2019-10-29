import sympy

from mako.template import Template
from pathlib import Path

from . import memory

class Generator:
    def __init__(self, descriptor, moments, collision, target, precision, index, layout):
        self.descriptor = descriptor
        self.moments    = moments
        self.collision  = collision
        self.target     = target
        self.float_type = eval("memory.precision.%s" % target).get_float_type(precision)

        try:
            self.index_impl = eval("memory.index.%s" % index)
        except AttributeError:
            raise Exception("There is no cell indexing scheme '%s'" % index) from None

        try:
            self.layout_impl = eval("memory.layout.%s" % layout)
        except AttributeError:
            raise Exception("There is no layout '%s'" % layout) from None

    def instantiate(self, template, geometry, extras = []):
        template_path = Path(__file__).parent/("template/%s.%s.mako" % (template, self.target))
        if not template_path.exists():
            raise Exception("Target '%s' doesn't provide '%s'" % (self.target, template))

        return Template(filename = str(template_path)).render(
            descriptor = self.descriptor,
            geometry   = geometry,
            index      = self.index_impl(geometry),
            layout     = self.layout_impl(self.descriptor, self.index_impl, geometry),

            moments_subexpr    = self.moments[0],
            moments_assignment = self.moments[1],
            collision_subexpr    = self.collision[0],
            collision_assignment = self.collision[1],
            ccode = sympy.ccode,

            float_type = self.float_type,

            extras = extras
        )

    def kernel(self, geometry, functions, extras = []):
        if geometry.dimension() != self.descriptor.d:
            raise Exception('Geometry dimension must match descriptor dimension')

        return "\n".join(map(lambda f: self.instantiate(f, geometry, extras), functions))

    def custom(self, geometry, source):
        return Template(text = source).render(
            descriptor = self.descriptor,
            geometry   = geometry,
            index      = self.index_impl(geometry),
            layout     = self.layout_impl(self.descriptor, self.index_impl, geometry),

            moments_subexpr    = self.moments[0],
            moments_assignment = self.moments[1],
            collision_subexpr    = self.collision[0],
            collision_assignment = self.collision[1],
            ccode = sympy.ccode,

            float_type = self.float_type,
        )
