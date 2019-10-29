__kernel void equilibrilize_gid(__global ${float_type}* f_next,
                                __global ${float_type}* f_prev,
                                unsigned int gid)
{
    __global ${float_type}* preshifted_f_next = f_next + ${layout.cell_preshift('gid')};
    __global ${float_type}* preshifted_f_prev = f_prev + ${layout.cell_preshift('gid')};

% for i, w_i in enumerate(descriptor.w):
    preshifted_f_next[${layout.pop_offset(i)}] = ${w_i}.f;
    preshifted_f_prev[${layout.pop_offset(i)}] = ${w_i}.f;
% endfor
}

% if 'cell_list_dispatch' in extras:
__kernel void equilibrilize_cells(__global ${float_type}* f_next,
                                  __global ${float_type}* f_prev,
                                  __global unsigned int*  cells)
{
    equilibrilize_gid(f_next, f_prev, cells[get_global_id(0)]);
}
% endif
