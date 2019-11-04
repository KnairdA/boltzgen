<%namespace name="pattern" file="${'/pattern/%s.cpp.mako' % context['streaming']}"/>
<%
import sympy
moments_subexpr, moments_assignment = model.moments()
%>

<%call expr="pattern.functor('collect_moments', [('%s&' % float_type, 'rho'), (float_type, 'u[%d]' % descriptor.d)])">
% for i, expr in enumerate(moments_subexpr):
    const ${float_type} ${expr[0]} = ${sympy.ccode(expr[1])};
% endfor

% for i, expr in enumerate(moments_assignment):
%   if i == 0:
    rho = ${sympy.ccode(expr.rhs)};
%   else:
    u[${i-1}] = ${sympy.ccode(expr.rhs)};
%   endif
% endfor
</%call>
