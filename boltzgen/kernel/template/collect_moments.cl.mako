__kernel void collect_moments(__global ${float_type}* f,
                              __global ${float_type}* moments)
{
    const unsigned int gid = ${layout.gid()};

    __global ${float_type}* preshifted_f = f + gid;

% for i in range(0,descriptor.q):
    const ${float_type} f_curr_${i} = preshifted_f[${layout.pop_offset(i)}];
% endfor

% for i, expr in enumerate(moments_subexpr):
    const ${float_type} ${expr[0]} = ${ccode(expr[1])};
% endfor

% for i, expr in enumerate(moments_assignment):
    moments[${layout.pop_offset(i)} + gid] = ${ccode(expr.rhs)};
% endfor
}
