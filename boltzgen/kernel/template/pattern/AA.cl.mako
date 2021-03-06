<%def name="operator(name, params = None)">
__kernel void ${name}_tick(
      __global ${float_type}* f
% if 'cell_list_dispatch' in extras:
    , __global unsigned int* cells
% else:
    , unsigned int gid
% endif
% if params is not None:
% for param_type, param_name in params:
    , ${param_type} ${param_name}
% endfor
% endif
) {
% if 'cell_list_dispatch' in extras:
    const unsigned int gid = cells[get_global_id(0)];
% endif
    __global ${float_type}* preshifted_f = f + ${layout.cell_preshift('gid')};

% for i, c_i in enumerate(descriptor.c):
    const ${float_type} f_curr_${i} = preshifted_f[${layout.pop_offset(i)}];
% endfor

    ${caller.body()}

% for i, c_i in enumerate(descriptor.c):
    preshifted_f[${layout.pop_offset(i)}] = f_next_${descriptor.c.index(-c_i)};
% endfor
}

__kernel void ${name}_tock(
      __global ${float_type}* f
% if 'cell_list_dispatch' in extras:
    , __global unsigned int* cells
% else:
    , unsigned int gid
% endif
% if params is not None:
% for param_type, param_name in params:
    , ${param_type} ${param_name}
% endfor
% endif
) {
% if 'cell_list_dispatch' in extras:
    const unsigned int gid = cells[get_global_id(0)];
% endif
    __global ${float_type}* preshifted_f = f + ${layout.cell_preshift('gid')};

% for i, c_i in enumerate(descriptor.c):
    const ${float_type} f_curr_${descriptor.c.index(-c_i)} = preshifted_f[${layout.pop_offset(i) + layout.neighbor_offset(c_i)}];
% endfor

    ${caller.body()}

% for i, c_i in enumerate(descriptor.c):
    preshifted_f[${layout.pop_offset(i) + layout.neighbor_offset(c_i)}] = f_next_${i};
% endfor
}
</%def>

<%def name="operator_with_domain_dispatch(name, params = None)">
__kernel void ${name}_tick(
      __global ${float_type}* f
% if params is not None:
% for param_type, param_name in params:
    , ${param_type} ${param_name}
% endfor
% endif
) {
    const unsigned int gid = ${index.gid('get_global_id(0)', 'get_global_id(1)', 'get_global_id(2)')};
    __global ${float_type}* preshifted_f = f + ${layout.cell_preshift('gid')};

% for i, c_i in enumerate(descriptor.c):
    const ${float_type} f_curr_${i} = preshifted_f[${layout.pop_offset(i)}];
% endfor

    ${caller.body()}

% for i, c_i in enumerate(descriptor.c):
    preshifted_f[${layout.pop_offset(i)}] = f_next_${descriptor.c.index(-c_i)};
% endfor
}

__kernel void ${name}_tock(
      __global ${float_type}* f
% if params is not None:
% for param_type, param_name in params:
    , ${param_type} ${param_name}
% endfor
% endif
) {
    const unsigned int gid = ${index.gid('get_global_id(0)', 'get_global_id(1)', 'get_global_id(2)')};
    __global ${float_type}* preshifted_f = f + ${layout.cell_preshift('gid')};

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
__kernel void ${name}_tick(
      __global ${float_type}* f
% if 'cell_list_dispatch' in extras:
    , __global unsigned int* cells
% else:
    , unsigned int gid
% endif
% if params is not None:
% for param_type, param_name in params:
    , ${param_type} ${param_name}
% endfor
% endif
) {
% if 'cell_list_dispatch' in extras:
    const unsigned int gid = cells[get_global_id(0)];
% endif
    __global ${float_type}* preshifted_f = f + ${layout.cell_preshift('gid')};

% for i, c_i in enumerate(descriptor.c):
    const ${float_type} f_curr_${i} = preshifted_f[${layout.pop_offset(descriptor.c.index(-c_i))}];
% endfor

    ${caller.body()}
}

__kernel void ${name}_tock(
      __global ${float_type}* f
% if 'cell_list_dispatch' in extras:
    , __global unsigned int* cells
% else:
    , unsigned int gid
% endif
% if params is not None:
% for param_type, param_name in params:
    , ${param_type} ${param_name}
% endfor
% endif
) {
% if 'cell_list_dispatch' in extras:
    const unsigned int gid = cells[get_global_id(0)];
% endif
    __global ${float_type}* preshifted_f = f + ${layout.cell_preshift('gid')};

% for i, c_i in enumerate(descriptor.c):
    const ${float_type} f_curr_${i} = preshifted_f[${layout.pop_offset(i) + layout.neighbor_offset(c_i)}];
% endfor

    ${caller.body()}
}
</%def>

<%def name="functor_with_domain_dispatch(name, params = None)">
__kernel void ${name}_tick(
      __global ${float_type}* f
% if params is not None:
% for param_type, param_name in params:
    , ${param_type} ${param_name}
% endfor
% endif
) {
    const unsigned int gid = ${index.gid('get_global_id(0)', 'get_global_id(1)', 'get_global_id(2)')};
    __global ${float_type}* preshifted_f = f + ${layout.cell_preshift('gid')};

% for i, c_i in enumerate(descriptor.c):
    const ${float_type} f_curr_${i} = preshifted_f[${layout.pop_offset(descriptor.c.index(-c_i))}];
% endfor

    ${caller.body()}
}

__kernel void ${name}_tock(
      __global ${float_type}* f
% if params is not None:
% for param_type, param_name in params:
    , ${param_type} ${param_name}
% endfor
% endif
) {
    const unsigned int gid = ${index.gid('get_global_id(0)', 'get_global_id(1)', 'get_global_id(2)')};
    __global ${float_type}* preshifted_f = f + ${layout.cell_preshift('gid')};

% for i, c_i in enumerate(descriptor.c):
    const ${float_type} f_curr_${i} = preshifted_f[${layout.pop_offset(i) + layout.neighbor_offset(c_i)}];
% endfor

    ${caller.body()}
}
</%def>
