<%namespace name="pattern" file="${'/pattern/%s.cuda.mako' % context['streaming']}"/>
<%
from boltzgen.utility.printer import CudaCodePrinter
ccode = CudaCodePrinter(float_type).doprint
%>

<%call expr="pattern.operator('equilibrilize')">
% for i, w_i in enumerate(descriptor.w):
    const ${float_type} f_next_${i} = ${ccode(w_i.evalf())};
% endfor
</%call>
