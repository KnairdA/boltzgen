<%
moments_subexpr, moments_assignment = model.moments()
collision_subexpr, collision_assignment = model.collision(f_eq = model.equilibrium(resolve_moments = False))
%>

<%def name="momenta_boundary(name, param)">
void ${name}_momenta_boundary(
          ${float_type}* f_next,
    const ${float_type}* f_prev,
    std::size_t gid, ${param})
{
          ${float_type}* preshifted_f_next = f_next + ${layout.cell_preshift('gid')};
    const ${float_type}* preshifted_f_prev = f_prev + ${layout.cell_preshift('gid')};

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

% for i, expr in enumerate(collision_assignment):
    preshifted_f_next[${layout.pop_offset(i)}] = f_next_${i};
% endfor
}
</%def>

<%call expr="momenta_boundary('velocity', '%s velocity[%d]' % (float_type, descriptor.d))">
    ${float_type} ${ccode(moments_assignment[0])}
% for i, expr in enumerate(moments_assignment[1:]):
    ${float_type} ${expr.lhs} = velocity[${i}];
% endfor
</%call>

<%call expr="momenta_boundary('density', '%s density' % float_type)">
    ${float_type} ${moments_assignment[0].lhs} = density;
% for i, expr in enumerate(moments_assignment[1:]):
    ${float_type} ${ccode(expr)}
% endfor
</%call>
