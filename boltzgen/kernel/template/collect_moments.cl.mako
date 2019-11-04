<%namespace name="pattern" file="${'/pattern/%s.cl.mako' % context['streaming']}"/>
<%
import sympy
moments_subexpr, moments_assignment = model.moments()
%>

<%call expr="pattern.functor_ab('collect_moments', [('__global %s*' % float_type, 'm')])">
% for i, expr in enumerate(moments_subexpr):
    const ${float_type} ${expr[0]} = ${sympy.ccode(expr[1])};
% endfor

    __global ${float_type}* preshifted_m = m + gid*${descriptor.d+1};

% for i, expr in enumerate(moments_assignment):
    preshifted_m[${i}] = ${sympy.ccode(expr.rhs)};
% endfor
</%call>

% if 'cell_list_dispatch' in extras:
__kernel void collect_moments_cells(__global ${float_type}* f,
                                    __global ${float_type}* m,
                                    __global unsigned int*  cells)
{
    collect_moments(f, cells[get_global_id(0)], m);
}
% endif
