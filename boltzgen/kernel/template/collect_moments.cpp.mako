<%
import sympy
%>

void collect_moments(const ${float_type}* f,
                     std::size_t gid,
                     ${float_type}& rho,
                     ${float_type} u[${descriptor.d}])
{
    const ${float_type}* preshifted_f = f + ${layout.cell_preshift('gid')};

% for i in range(0,descriptor.q):
    const ${float_type} f_curr_${i} = preshifted_f[${layout.pop_offset(i)}];
% endfor

<%
    moments_subexpr, moments_assignment = model.moments()
%>

% for i, expr in enumerate(moments_subexpr):
    const ${float_type} ${expr[0]} = ${sympy.ccode(expr[1])};
% endfor

% for i, expr in enumerate(moments_assignment):
%   if i == 0:
    rho = ${sympy.ccode(expr.rhs)};
%   else:
    u[${i-1}] = ${sympy.ccode(expr.rhs)};
%   endif
% endfor
}

