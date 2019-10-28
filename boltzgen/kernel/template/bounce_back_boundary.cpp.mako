void bounce_back_boundary(      ${float_type}* f_next,
                          const ${float_type}* f_prev,
                          std::size_t gid)
{
          ${float_type}* preshifted_f_next = f_next + gid*${layout.gid_offset()};
    const ${float_type}* preshifted_f_prev = f_prev + gid*${layout.gid_offset()};

% for i, c_i in enumerate(descriptor.c):
    const ${float_type} f_curr_${i} = preshifted_f_prev[${layout.pop_offset(i) + layout.neighbor_offset(-c_i)}];
% endfor

% for i, expr in enumerate(moments_subexpr):
    const ${float_type} ${expr[0]} = ${ccode(expr[1])};
% endfor

% for i, expr in enumerate(moments_assignment):
    ${float_type} ${ccode(expr)}
% endfor

% for i, expr in enumerate(collision_subexpr):
    const ${float_type} ${expr[0]} = ${ccode(expr[1])};
% endfor

% for i, expr in enumerate(collision_assignment):
    const ${float_type} ${ccode(expr)}
% endfor

% for i, c_i in enumerate(descriptor.c):
    preshifted_f_next[${layout.pop_offset(i)}] = f_next_${descriptor.c.index(-c_i)};
% endfor
}
