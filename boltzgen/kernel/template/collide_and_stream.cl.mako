<%namespace name="pattern" file="${'/pattern/%s.cl.mako' % context['streaming']}"/>
<%
import sympy
subexpr, assignment = model.collision(f_eq = model.equilibrium(resolve_moments = True))
%>

<%call expr="pattern.operator_ab('collide_and_stream')">
% for i, expr in enumerate(subexpr):
    const ${float_type} ${expr[0]} = ${sympy.ccode(expr[1])};
% endfor

% for i, expr in enumerate(assignment):
    const ${float_type} ${sympy.ccode(expr)}
% endfor
</%call>
