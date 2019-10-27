<%def name="momenta_boundary(name, param)">
__kernel void ${name}_momenta_boundary_gid(
   __global ${float_type}* f_next,
   __global ${float_type}* f_prev,
   unsigned int gid, ${param})
{
    __global ${float_type}* preshifted_f_next = f_next + gid;
    __global ${float_type}* preshifted_f_prev = f_prev + gid;

% for i, c_i in enumerate(descriptor.c):
    const ${float_type} f_curr_${i} = preshifted_f_prev[${layout.pop_offset(i) + layout.neighbor_offset(-c_i)}];
% endfor

% for i, expr in enumerate(moments_subexpr):
    const ${float_type} ${expr[0]} = ${ccode(expr[1])};
% endfor

    ${caller.body()}

% for i, expr in enumerate(collision_subexpr):
    const ${float_type} ${expr[0]} = ${ccode(expr[1])};
% endfor

% for i, expr in enumerate(collision_assignment):
    const ${float_type} ${ccode(expr)}
% endfor

% for i in range(0,descriptor.q):
    preshifted_f_next[${layout.pop_offset(i)}] = f_next_${i};
% endfor
}
</%def>

<%call expr="momenta_boundary('velocity', '%s%d velocity' % (float_type, descriptor.d))">
    ${float_type} ${ccode(moments_assignment[0])}
% for i, expr in enumerate(moments_assignment[1:]):
    ${float_type} ${expr.lhs} = velocity.${['x', 'y', 'z'][i]};
% endfor
</%call>

<%call expr="momenta_boundary('density', '%s density' % float_type)">
    ${float_type} ${moments_assignment[0].lhs} = density;
% for i, expr in enumerate(moments_assignment[1:]):
    ${float_type} ${ccode(expr)}
% endfor
</%call>

% if 'cell_list_dispatch' in extras:
__kernel void velocity_momenta_boundary_cells(__global ${float_type}* f_next,
                                              __global ${float_type}* f_prev,
                                              __global unsigned int*  cells,
                                              ${float_type}${descriptor.d} velocity)
{
    velocity_momenta_boundary_gid(f_next, f_prev, cells[get_global_id(0)], velocity);
}

__kernel void density_momenta_boundary_cells(__global ${float_type}* f_next,
                                             __global ${float_type}* f_prev,
                                             __global unsigned int*  cells,
                                             ${float_type} density)
{
    density_momenta_boundary_gid(f_next, f_prev, cells[get_global_id(0)], density);
}
% endif
