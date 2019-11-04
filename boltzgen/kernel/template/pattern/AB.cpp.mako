<%def name="operator(name, params = None)">
void ${name}(
            ${float_type}* f_next
    , const ${float_type}* f_prev
    , std::size_t gid
% if params is not None:
% for param_type, param_name in params:
    , ${param_type} ${param_name}
% endfor
% endif
) {
          ${float_type}* preshifted_f_next = f_next + ${layout.cell_preshift('gid')};
    const ${float_type}* preshifted_f_prev = f_prev + ${layout.cell_preshift('gid')};

% for i, c_i in enumerate(descriptor.c):
    const ${float_type} f_curr_${i} = preshifted_f_prev[${layout.pop_offset(i) + layout.neighbor_offset(-c_i)}];
% endfor

    ${caller.body()}

% for i, _ in enumerate(descriptor.c):
    preshifted_f_next[${layout.pop_offset(i)}] = f_next_${i};
% endfor
}
</%def>

<%def name="functor(name, params = None)">
void ${name}(
      const ${float_type}* f
    , std::size_t gid
% if params is not None:
% for param_type, param_name in params:
    , ${param_type} ${param_name}
% endfor
% endif
) {
    const ${float_type}* preshifted_f = f + ${layout.cell_preshift('gid')};

% for i in range(0,descriptor.q):
    const ${float_type} f_curr_${i} = preshifted_f[${layout.pop_offset(i)}];
% endfor

    ${caller.body()}
}
</%def>
