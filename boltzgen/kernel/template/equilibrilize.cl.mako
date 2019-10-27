__kernel void equilibrilize(__global ${float_type}* f_next,
                            __global ${float_type}* f_prev)
{
    const unsigned int gid = ${layout.gid()};

    __global ${float_type}* preshifted_f_next = f_next + gid;
    __global ${float_type}* preshifted_f_prev = f_prev + gid;

% for i, w_i in enumerate(descriptor.w):
    preshifted_f_next[${layout.pop_offset(i)}] = ${w_i}.f;
    preshifted_f_prev[${layout.pop_offset(i)}] = ${w_i}.f;
% endfor
}
