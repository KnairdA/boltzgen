void equilibrilize(${float_type}* f_next,
                   ${float_type}* f_prev,
                   std::size_t gid)
{
    ${float_type}* preshifted_f_next = f_next + gid*${layout.gid_offset()};
    ${float_type}* preshifted_f_prev = f_prev + gid*${layout.gid_offset()};

% for i, w_i in enumerate(descriptor.w):
    preshifted_f_next[${layout.pop_offset(i)}] = ${w_i.evalf()};
    preshifted_f_prev[${layout.pop_offset(i)}] = ${w_i.evalf()};
% endfor
}

