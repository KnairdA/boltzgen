void collide_and_stream(      ${float_type}* f_next,
                        const ${float_type}* f_prev,
                        std::size_t gid)
{
          ${float_type}* preshifted_f_next = f_next + ${layout.cell_preshift('gid')};
    const ${float_type}* preshifted_f_prev = f_prev + ${layout.cell_preshift('gid')};

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

% for i, expr in enumerate(assignment):
    preshifted_f_next[${layout.pop_offset(i)}] = f_next_${i};
% endfor
}

