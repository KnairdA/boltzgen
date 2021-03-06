<%def name="operator(name, params = None)">
void ${name}_tick(
      ${float_type}* f
    , std::size_t gid
% if params is not None:
% for param_type, param_name in params:
    , ${param_type} ${param_name}
% endfor
% endif
) {
    ${float_type}* preshifted_f = f + ${layout.cell_preshift('gid')};

% for i, c_i in enumerate(descriptor.c):
    const ${float_type} f_curr_${i} = preshifted_f[${layout.pop_offset(i)}];
% endfor

    ${caller.body()}

% for i, c_i in enumerate(descriptor.c):
    preshifted_f[${layout.pop_offset(i)}] = f_next_${descriptor.c.index(-c_i)};
% endfor
}

void ${name}_tock(
      ${float_type}* f
    , std::size_t gid
% if params is not None:
% for param_type, param_name in params:
    , ${param_type} ${param_name}
% endfor
% endif
) {
    ${float_type}* preshifted_f = f + ${layout.cell_preshift('gid')};

% for i, c_i in enumerate(descriptor.c):
    const ${float_type} f_curr_${descriptor.c.index(-c_i)} = preshifted_f[${layout.pop_offset(i) + layout.neighbor_offset(c_i)}];
% endfor

    ${caller.body()}

% for i, c_i in enumerate(descriptor.c):
    preshifted_f[${layout.pop_offset(i) + layout.neighbor_offset(c_i)}] = f_next_${i};
% endfor
}
</%def>

<%def name="functor(name, params = None)">
void ${name}_tick(
      const ${float_type}* f
    , std::size_t gid
% if params is not None:
% for param_type, param_name in params:
    , ${param_type} ${param_name}
% endfor
% endif
) {
    const ${float_type}* preshifted_f = f + ${layout.cell_preshift('gid')};

% for i, c_i in enumerate(descriptor.c):
    const ${float_type} f_curr_${i} = preshifted_f[${layout.pop_offset(descriptor.c.index(-c_i))}];
% endfor

    ${caller.body()}
}

void ${name}_tock(
      const ${float_type}* f
    , std::size_t gid
% if params is not None:
% for param_type, param_name in params:
    , ${param_type} ${param_name}
% endfor
% endif
) {
    const ${float_type}* preshifted_f = f + ${layout.cell_preshift('gid')};

% for i, c_i in enumerate(descriptor.c):
    const ${float_type} f_curr_${i} = preshifted_f[${layout.pop_offset(i) + layout.neighbor_offset(c_i)}];
% endfor

    ${caller.body()}
}
</%def>
