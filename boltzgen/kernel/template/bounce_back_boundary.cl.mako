<%namespace name="pattern" file="${'/pattern/%s.cl.mako' % context['streaming']}"/>
<%
import sympy
subexpr, assignment = model.collision(f_eq = model.equilibrium(resolve_moments = True))
%>

<%call expr="pattern.operator('bounce_back_boundary')">
% for i, expr in enumerate(subexpr):
    const ${float_type} ${expr[0]} = ${sympy.ccode(expr[1])};
% endfor

% for i, c_i in enumerate(descriptor.c):
    const ${float_type} ${assignment[i].lhs} = ${sympy.ccode(assignment[descriptor.c.index(-c_i)].rhs)};
% endfor
</%call>
