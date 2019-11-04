<%namespace name="pattern" file="${'/pattern/%s.cpp.mako' % context['streaming']}"/>

<%call expr="pattern.operator_ab('equilibrilize')">
% for i, w_i in enumerate(descriptor.w):
    ${float_type} f_next_${i} = ${w_i.evalf()};
% endfor
</%call>
