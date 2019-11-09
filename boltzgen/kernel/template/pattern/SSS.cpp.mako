<%def name="operator(name, params = None)">
<%
if layout.__class__.__name__ != 'SOA':
    raise Exception('SSS pattern only works for the AOS memory layout')
%>
void ${name}(
      ${float_type}** f
    , std::size_t gid
% if params is not None:
% for param_type, param_name in params:
    , ${param_type} ${param_name}
% endfor
% endif
) {
% for i, c_i in enumerate(descriptor.c):
    ${float_type}* preshifted_f_${i} = f[${i}] + ${layout.cell_preshift('gid')};
% endfor

% for i, c_i in enumerate(descriptor.c):
    const ${float_type} f_curr_${i} = *preshifted_f_${i};
% endfor

    ${caller.body()}

% for i, c_i in enumerate(descriptor.c):
    *preshifted_f_${i} = f_next_${descriptor.c.index(-c_i)};
% endfor
}
</%def>

<%def name="functor(name, params = None)">
<%
if layout.__class__.__name__ != 'SOA':
    raise Exception('SSS pattern only works for the AOS memory layout')
%>
void ${name}(
      ${float_type}** f
    , std::size_t gid
% if params is not None:
% for param_type, param_name in params:
    , ${param_type} ${param_name}
% endfor
% endif
) {
% for i, c_i in enumerate(descriptor.c):
    const ${float_type}* preshifted_f_${i} = f[${i}] + ${layout.cell_preshift('gid')};
% endfor

% for i, c_i in enumerate(descriptor.c):
    const ${float_type} f_curr_${i} = *preshifted_f_${descriptor.c.index(-c_i)};
% endfor

    ${caller.body()}
}
</%def>
