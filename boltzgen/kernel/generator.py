import sympy

from mako.template import Template
from pathlib import Path

def source(descriptor, moments, collide, boundary_src, float_type, geometry):
    return Template(filename = str(Path(__file__).parent/'template/kernel.mako')).render(
        descriptor = descriptor,
        geometry   = geometry,

        moments_subexpr    = moments[0],
        moments_assignment = moments[1],
        collide_subexpr    = collide[0],
        collide_assignment = collide[1],

        float_type = float_type,

        boundary_src = Template(boundary_src).render(
            descriptor = descriptor,
            geometry   = geometry,
            float_type = float_type
        ),

        ccode = sympy.ccode
    )
