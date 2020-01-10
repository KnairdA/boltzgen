<%def name="operator(name, params = None)">
<%
if layout.__class__.__name__ != 'SOA':
    raise Exception('SSS pattern only works for the AOS memory layout')
%>
__kernel void ${name}(
      __global uintptr_t* control
% if 'cell_list_dispatch' in extras:
    , __global unsigned* cells
% else:
    , std::size_t gid
% endif
% if params is not None:
% for param_type, param_name in params:
    , ${param_type} ${param_name}
% endfor
% endif
) {
% if 'cell_list_dispatch' in extras:
    const unsigned int gid = cells[get_global_id(0)];
% endif

% for i, c_i in enumerate(descriptor.c):
    __global ${float_type}* preshifted_f_${i} = ((__global ${float_type}*)control[${i}]) + ${layout.cell_preshift('gid')};
% endfor

% for i, c_i in enumerate(descriptor.c):
    const ${float_type} f_curr_${i} = *preshifted_f_${i};
% endfor

    ${caller.body()}

% for i, c_i in enumerate(descriptor.c):
    *preshifted_f_${i} = f_next_${descriptor.c.index(-c_i)};
% endfor
}
</%def>

<%def name="operator_with_domain_dispatch(name, params = None)">
__kernel void ${name}(
      __global uintptr_t* control
% if params is not None:
% for param_type, param_name in params:
    , ${param_type} ${param_name}
% endfor
% endif
) {
    const unsigned int gid = ${index.gid('get_global_id(0)', 'get_global_id(1)', 'get_global_id(2)')};

% for i, c_i in enumerate(descriptor.c):
    __global ${float_type}* preshifted_f_${i} = ((__global ${float_type}*)control[${i}]) + ${layout.cell_preshift('gid')};
% endfor

% for i, c_i in enumerate(descriptor.c):
    const ${float_type} f_curr_${i} = *preshifted_f_${i};
% endfor

    ${caller.body()}

% for i, c_i in enumerate(descriptor.c):
    *preshifted_f_${i} = f_next_${descriptor.c.index(-c_i)};
% endfor
}
</%def>

<%def name="functor(name, params = None)">
<%
if layout.__class__.__name__ != 'SOA':
    raise Exception('SSS pattern only works for the AOS memory layout')
%>
__kernel void ${name}(
      __global const uintptr_t* control
% if 'cell_list_dispatch' in extras:
    , __global unsigned* cells
% else:
    , std::size_t gid
% endif
% if params is not None:
% for param_type, param_name in params:
    , ${param_type} ${param_name}
% endfor
% endif
) {
% if 'cell_list_dispatch' in extras:
    const unsigned int gid = cells[get_global_id(0)];
% endif

% for i, c_i in enumerate(descriptor.c):
    __global const ${float_type}* preshifted_f_${i} = ((__global ${float_type}*)control[${i}]) + ${layout.cell_preshift('gid')};
% endfor

% for i, c_i in enumerate(descriptor.c):
    const ${float_type} f_curr_${i} = *preshifted_f_${descriptor.c.index(-c_i)};
% endfor

    ${caller.body()}
}
</%def>

<%def name="functor_with_domain_dispatch(name, params = None)">
__kernel void ${name}(
      __global const uintptr_t* control
% if params is not None:
% for param_type, param_name in params:
    , ${param_type} ${param_name}
% endfor
% endif
) {
    const unsigned int gid = ${index.gid('get_global_id(0)', 'get_global_id(1)', 'get_global_id(2)')};

% for i, c_i in enumerate(descriptor.c):
    __global const ${float_type}* preshifted_f_${i} = ((__global ${float_type}*)control[${i}]) + ${layout.cell_preshift('gid')};
% endfor

% for i, c_i in enumerate(descriptor.c):
    const ${float_type} f_curr_${i} = *preshifted_f_${i};
% endfor

    ${caller.body()}
}
</%def>
