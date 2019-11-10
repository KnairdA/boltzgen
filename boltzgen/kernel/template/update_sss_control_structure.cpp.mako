<%
if streaming != 'SSS':
    raise Exception('"update_sss_control_structure" function only makes sense for the SSS pattern')
%>
void update_sss_control_structure(${float_type}** f) {
% for i, c_i in enumerate(descriptor.c):
    ${float_type}* f_old_${i} = f[${i}];
% endfor
% for i, c_i in enumerate(descriptor.c):
    f[${i}]  = f_old_${descriptor.c.index(-c_i)} + ${layout.neighbor_offset(-c_i)};
% endfor
}
