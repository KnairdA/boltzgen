<%
if streaming != 'SSS':
    raise Exception('"update_sss_control_structure" function only makes sense for the SSS pattern')

padding = (max(geometry.size_x,geometry.size_y,geometry.size_z)+1)**(descriptor.d-1)
%>

__kernel void init_sss_control_structure(__global ${float_type}* f, __global uintptr_t* control) {
% for i, c_i in enumerate(descriptor.c):
    control[${i}]  = (uintptr_t)(f + ${padding + layout.pop_offset(i, 2*padding)});
% endfor
}

__kernel void update_sss_control_structure(__global uintptr_t* control) {
% for i, c_i in enumerate(descriptor.c):
    __global ${float_type}* f_old_${i} = (__global ${float_type}*)(control[${i}]);
% endfor
% for i, c_i in enumerate(descriptor.c):
    control[${i}] = (uintptr_t)(f_old_${descriptor.c.index(-c_i)} + ${layout.neighbor_offset(-c_i)});
% endfor
}
