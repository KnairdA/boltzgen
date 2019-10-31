__kernel void collect_moments_gid(__global ${float_type}* f,
                                  __global ${float_type}* m,
                                  unsigned int gid)
{
    __global ${float_type}* preshifted_f = f + ${layout.cell_preshift('gid')};
    __global ${float_type}* preshifted_m = m + gid*${descriptor.d+1};

% for i in range(0,descriptor.q):
    const ${float_type} f_curr_${i} = preshifted_f[${layout.pop_offset(i)}];
% endfor

<%
    moments_subexpr, moments_assignment = model.moments()
%>

% for i, expr in enumerate(moments_subexpr):
    const ${float_type} ${expr[0]} = ${ccode(expr[1])};
% endfor

% for i, expr in enumerate(moments_assignment):
    preshifted_m[${i}] = ${ccode(expr.rhs)};
% endfor
}

% if 'cell_list_dispatch' in extras:
__kernel void collect_moments_cells(__global ${float_type}* f,
                                    __global ${float_type}* moments,
                                    __global unsigned int*  cells)
{
    collect_moments_gid(f, moments, cells[get_global_id(0)]);
}
% endif
