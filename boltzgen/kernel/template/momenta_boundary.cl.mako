<%namespace name="pattern" file="${'/pattern/%s.cl.mako' % context['streaming']}"/>
<%
import sympy
moments_subexpr, moments_assignment = model.moments()
collision_subexpr, collision_assignment = model.collision(f_eq = model.equilibrium(resolve_moments = False))
%>

<%def name="momenta_boundary(name, params)">
<%call expr="pattern.operator('%s_momenta_boundary' % name, params)">
% for i, expr in enumerate(moments_subexpr):
    const ${float_type} ${expr[0]} = ${sympy.ccode(expr[1])};
% endfor

    ${caller.body()}

% for i, expr in enumerate(collision_subexpr):
    const ${float_type} ${expr[0]} = ${sympy.ccode(expr[1])};
% endfor

% for i, expr in enumerate(collision_assignment):
    const ${float_type} ${sympy.ccode(expr)}
% endfor
</%call>
</%def>

<%call expr="momenta_boundary('velocity', [('%s%d' % (float_type, descriptor.d), 'velocity')])">
    const ${float_type} ${sympy.ccode(moments_assignment[0])}
% for i, expr in enumerate(moments_assignment[1:]):
    const ${float_type} ${expr.lhs} = velocity.${['x','y','z'][i]};
% endfor
</%call>

<%call expr="momenta_boundary('density', [(float_type, 'density')])">
    const ${float_type} ${moments_assignment[0].lhs} = density;
% for i, expr in enumerate(moments_assignment[1:]):
    const ${float_type} ${sympy.ccode(expr)}
% endfor
</%call>
