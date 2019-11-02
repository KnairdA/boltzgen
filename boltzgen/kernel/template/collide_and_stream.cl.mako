__kernel void collide_and_stream_gid(__global ${float_type}* f_next,
                                     __global ${float_type}* f_prev,
                                     unsigned int gid)
{
    __global ${float_type}* preshifted_f_next = f_next + ${layout.cell_preshift('gid')};
    __global ${float_type}* preshifted_f_prev = f_prev + ${layout.cell_preshift('gid')};

% for i, c_i in enumerate(descriptor.c):
    const ${float_type} f_curr_${i} = preshifted_f_prev[${layout.pop_offset(i) + layout.neighbor_offset(-c_i)}];
% endfor

<%
    subexpr, assignment = model.collision(f_eq = model.equilibrium(resolve_moments = True))
%>

% for i, expr in enumerate(subexpr):
    const ${float_type} ${expr[0]} = ${ccode(expr[1])};
% endfor

% for i, expr in enumerate(assignment):
    const ${float_type} ${ccode(expr)}
% endfor

% for i in range(0,descriptor.q):
    preshifted_f_next[${layout.pop_offset(i)}] = f_next_${i};
% endfor
}

% if 'cell_list_dispatch' in extras:
__kernel void collide_and_stream_cells(__global ${float_type}* f_next,
                                       __global ${float_type}* f_prev,
                                       __global unsigned int*  cells)
{
    collide_and_stream_gid(f_next, f_prev, cells[get_global_id(0)]);
}
% endif
