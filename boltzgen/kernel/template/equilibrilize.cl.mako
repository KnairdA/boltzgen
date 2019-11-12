<%namespace name="pattern" file="${'/pattern/%s.cl.mako' % context['streaming']}"/>

<%call expr="pattern.operator('equilibrilize')">
% for i, w_i in enumerate(descriptor.w):
    const ${float_type} f_next_${i} = ${w_i.evalf()};
% endfor
</%call>

<%call expr="pattern.operator_with_domain_dispatch('equilibrilize_domain')">
% for i, w_i in enumerate(descriptor.w):
    const ${float_type} f_next_${i} = ${w_i.evalf()};
% endfor
</%call>
