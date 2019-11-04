<%def name="operator_ab(name, params = None)">
__kernel void ${name}(
      __global ${float_type}* f_next
    , __global ${float_type}* f_prev
    , unsigned int gid
% if params is not None:
% for param_type, param_name in params:
    , ${param_type} ${param_name}
% endfor
% endif
) {
    __global ${float_type}* preshifted_f_next = f_next + ${layout.cell_preshift('gid')};
    __global ${float_type}* preshifted_f_prev = f_prev + ${layout.cell_preshift('gid')};

% for i, c_i in enumerate(descriptor.c):
    const ${float_type} f_curr_${i} = preshifted_f_prev[${layout.pop_offset(i) + layout.neighbor_offset(-c_i)}];
% endfor

    ${caller.body()}

% for i, _ in enumerate(descriptor.c):
    preshifted_f_next[${layout.pop_offset(i)}] = f_next_${i};
% endfor
}

% if 'cell_list_dispatch' in extras:
__kernel void ${name}_cells(
      __global ${float_type}* f_next
    , __global ${float_type}* f_prev
    , __global unsigned int* cells
% if params is not None:
% for param_type, param_name in params:
    , ${param_type} ${param_name}
% endfor
% endif
) {
    ${name}(
          f_next
        , f_prev
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

<%def name="functor_ab(name, params = None)">
__kernel void ${name}(
      __global ${float_type}* f
    , unsigned int gid
% if params is not None:
% for param_type, param_name in params:
    , ${param_type} ${param_name}
% endfor
% endif
) {
    __global ${float_type}* preshifted_f = f + ${layout.cell_preshift('gid')};

% for i in range(0,descriptor.q):
    const ${float_type} f_curr_${i} = preshifted_f[${layout.pop_offset(i)}];
% endfor

    ${caller.body()}
}
</%def>
