<%
if streaming != 'SSS':
    raise Exception('"update_sss_control_structure" function only makes sense for the SSS pattern')

padding = (max(geometry.size_x,geometry.size_y,geometry.size_z)+1)**(descriptor.d-1)
%>

__global__ void init_sss_control_structure(${float_type}* f, ${float_type}** control) {
% for i, c_i in enumerate(descriptor.c):
    control[${i}]  = f + ${padding + layout.pop_offset(i, 2*padding)};
% endfor
}

__global__ void update_sss_control_structure(${float_type}** f) {
% for i, c_i in enumerate(descriptor.c):
    ${float_type}* f_old_${i} = f[${i}];
% endfor
% for i, c_i in enumerate(descriptor.c):
    f[${i}]  = f_old_${descriptor.c.index(-c_i)} + ${layout.neighbor_offset(-c_i)};
% endfor
}
