<%namespace name="pattern" file="${'/pattern/%s.cuda.mako' % context['streaming']}"/>
<%
from boltzgen.utility.printer import CudaCodePrinter
ccode = CudaCodePrinter(float_type).doprint
subexpr, assignment = model.collision(f_eq = model.equilibrium(resolve_moments = True))

%>

<%call expr="pattern.operator('collide')">
% for i, expr in enumerate(subexpr):
    const ${float_type} ${expr[0]} = ${ccode(expr[1])};
% endfor

% for i, expr in enumerate(assignment):
    const ${float_type} ${ccode(expr)}
% endfor
</%call>
