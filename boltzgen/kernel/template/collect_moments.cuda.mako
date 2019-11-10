<%namespace name="pattern" file="${'/pattern/%s.cuda.mako' % context['streaming']}"/>
<%
from boltzgen.utility.printer import CudaCodePrinter
ccode = CudaCodePrinter(float_type).doprint
moments_subexpr, moments_assignment = model.moments()
%>

<%call expr="pattern.functor('collect_moments', [('%s*' % float_type, 'rho'), ('%s*' % float_type, 'u')])">
% for i, expr in enumerate(moments_subexpr):
    const ${float_type} ${expr[0]} = ${ccode(expr[1])};
% endfor

% for i, expr in enumerate(moments_assignment):
%   if i == 0:
    rho[gid] = ${ccode(expr.rhs)};
%   else:
    u[gid*${descriptor.d} + ${i-1}] = ${ccode(expr.rhs)};
%   endif
% endfor
</%call>
