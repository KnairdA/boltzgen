<%def name="operator(name, params = None)">
__kernel void ${name}_tick(
      __global ${float_type}* f
    , unsigned int gid
% if params is not None:
% for param_type, param_name in params:
    , ${param_type} ${param_name}
% endfor
% endif
) {
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
    , unsigned int gid
% if params is not None:
% for param_type, param_name in params:
    , ${param_type} ${param_name}
% endfor
% endif
) {
    __global ${float_type}* preshifted_f = f + ${layout.cell_preshift('gid')};

% for i, c_i in enumerate(descriptor.c):
    const ${float_type} f_curr_${descriptor.c.index(-c_i)} = preshifted_f[${layout.pop_offset(i) + layout.neighbor_offset(c_i)}];
% endfor

    ${caller.body()}

% for i, c_i in enumerate(descriptor.c):
    preshifted_f[${layout.pop_offset(i) + layout.neighbor_offset(c_i)}] = f_next_${i};
% endfor
}

% if 'cell_list_dispatch' in extras:
__kernel void ${name}_cells_tick(
      __global ${float_type}* f
    , __global unsigned int* cells
% if params is not None:
% for param_type, param_name in params:
    , ${param_type} ${param_name}
% endfor
% endif
) {
    ${name}_tick(
          f
        , cells[get_global_id(0)]
% if params is not None:
% for param_type, param_name in params:
        , ${param_name}
% endfor
% endif
    );
}

__kernel void ${name}_cells_tock(
      __global ${float_type}* f
    , __global unsigned int* cells
% if params is not None:
% for param_type, param_name in params:
    , ${param_type} ${param_name}
% endfor
% endif
) {
    ${name}_tock(
          f
        , cells[get_global_id(0)]
% if params is not None:
% for param_type, param_name in params:
        , ${param_name}
% endfor
% endif
    );
}
% endif
</%def>

<%def name="functor(name, params = None)">
__kernel void ${name}_tick(
      __global ${float_type}* f
    , unsigned int gid
% if params is not None:
% for param_type, param_name in params:
    , ${param_type} ${param_name}
% endfor
% endif
) {
    __global ${float_type}* preshifted_f = f + ${layout.cell_preshift('gid')};

% for i, c_i in enumerate(descriptor.c):
    const ${float_type} f_curr_${i} = preshifted_f[${layout.pop_offset(descriptor.c.index(-c_i))}];
% endfor

    ${caller.body()}
}

__kernel void ${name}_tock(
      __global ${float_type}* f
    , unsigned int gid
% if params is not None:
% for param_type, param_name in params:
    , ${param_type} ${param_name}
% endfor
% endif
) {
    __global ${float_type}* preshifted_f = f + ${layout.cell_preshift('gid')};

% for i, c_i in enumerate(descriptor.c):
    const ${float_type} f_curr_${i} = preshifted_f[${layout.pop_offset(i) + layout.neighbor_offset(c_i)}];
% endfor

    ${caller.body()}
}

% if 'cell_list_dispatch' in extras:
__kernel void ${name}_cells_tick(
      __global ${float_type}* f
    , __global unsigned int* cells
% if params is not None:
% for param_type, param_name in params:
    , ${param_type} ${param_name}
% endfor
% endif
) {
    ${name}_tick(
          f
        , cells[get_global_id(0)]
% if params is not None:
% for param_type, param_name in params:
        , ${param_name}
% endfor
% endif
    );
}

__kernel void ${name}_cells_tock(
      __global ${float_type}* f
    , __global unsigned int* cells
% if params is not None:
% for param_type, param_name in params:
    , ${param_type} ${param_name}
% endfor
% endif
) {
    ${name}_tock(
          f
        , cells[get_global_id(0)]
% if params is not None:
% for param_type, param_name in params:
        , ${param_name}
% endfor
% endif
    );
}
% endif
</%def>
