<%
def pop_offset(i):
    return i * geometry.volume

def neighbor_offset(c_i):
    return {
        2: lambda:                                          c_i[1]*geometry.size_x + c_i[0],
        3: lambda: c_i[2]*geometry.size_x*geometry.size_y + c_i[1]*geometry.size_x + c_i[0]
    }.get(descriptor.d)()

def padding():
    return {
        2: lambda:                                     1*geometry.size_x + 1,
        3: lambda: 1*geometry.size_x*geometry.size_y + 1*geometry.size_x + 1
    }.get(descriptor.d)()
%>

void equilibrilize(${float_type}* f_next,
                   ${float_type}* f_prev,
                   std::size_t gid)
{
    ${float_type}* preshifted_f_next = f_next + gid;
    ${float_type}* preshifted_f_prev = f_prev + gid;

% for i, w_i in enumerate(descriptor.w):
    preshifted_f_next[${pop_offset(i)}] = ${w_i.evalf()};
    preshifted_f_prev[${pop_offset(i)}] = ${w_i.evalf()};
% endfor
}

void collide_and_stream(      ${float_type}* f_next,
                        const ${float_type}* f_prev,
                        const int*  material,
                        std::size_t gid)
{
    const int m = material[gid];

          ${float_type}* preshifted_f_next = f_next + gid;
    const ${float_type}* preshifted_f_prev = f_prev + gid;

% for i, c_i in enumerate(descriptor.c):
    const ${float_type} f_curr_${i} = preshifted_f_prev[${pop_offset(i) + neighbor_offset(-c_i)}];
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

% for i, expr in enumerate(collision_assignment):
    preshifted_f_next[${pop_offset(i)}] = m*f_next_${i} + (1.0-m)*${descriptor.w[i].evalf()};
% endfor
}

void collect_moments(const ${float_type}* f,
                     std::size_t gid,
                     ${float_type}& rho,
                     ${float_type} u[${descriptor.d}])
{
    const ${float_type}* preshifted_f = f + gid;

% for i in range(0,descriptor.q):
    const ${float_type} f_curr_${i} = preshifted_f[${pop_offset(i)}];
% endfor

% for i, expr in enumerate(moments_subexpr):
    const ${float_type} ${expr[0]} = ${ccode(expr[1])};
% endfor

% for i, expr in enumerate(moments_assignment):
%   if i == 0:
    rho = ${ccode(expr.rhs)};
%   else:
    u[${i-1}] = ${ccode(expr.rhs)};
%   endif
% endfor
}
