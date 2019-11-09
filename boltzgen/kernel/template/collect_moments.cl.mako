<%namespace name="pattern" file="${'/pattern/%s.cl.mako' % context['streaming']}"/>
<%
import sympy
moments_subexpr, moments_assignment = model.moments()
%>

<%call expr="pattern.functor('collect_moments', [('__global %s*' % float_type, 'm')])">
% for i, expr in enumerate(moments_subexpr):
    const ${float_type} ${expr[0]} = ${sympy.ccode(expr[1])};
% endfor

    __global ${float_type}* preshifted_m = m + gid*${descriptor.d+1};

% for i, expr in enumerate(moments_assignment):
    preshifted_m[${i}] = ${sympy.ccode(expr.rhs)};
% endfor
</%call>

% if 'opencl_gl_interop' in extras:
<%call expr="pattern.functor_with_domain_dispatch('collect_moments_to_texture', [('__write_only %s' % {2: 'image2d_t', 3: 'image3d_t'}.get(descriptor.d), 'm')])">
% for i, expr in enumerate(moments_subexpr):
    const ${float_type} ${expr[0]} = ${sympy.ccode(expr[1])};
% endfor

    float4 data;
% for i, expr in enumerate(moments_assignment):
    data.${['x','y','z','w'][i]} = ${sympy.ccode(expr.rhs)};
% endfor
% if descriptor.d == 2:
    data.w = sqrt(data.y*data.y + data.z*data.z);
% endif

<%
def moments_cell():
    return {
        2: '(int2)(get_global_id(0), get_global_id(1))',
        3: '(int4)(get_global_id(0), get_global_id(1), get_global_id(2), 0)'
    }.get(descriptor.d)
%>
    write_imagef(m, ${moments_cell()}, data);
</%call>
% endif
