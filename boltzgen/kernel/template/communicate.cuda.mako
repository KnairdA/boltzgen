<%
import numpy

directions = list(filter(lambda c: numpy.sum(numpy.abs(c)) == 1, descriptor.c))

def name(direction):
    names = [ ('west','','east'), ('south','','north'), ('down','','up') ]
    return ''.join([ names[i][v+1] for i, v in enumerate(direction) ])

def neighbors(direction):
    j = list(direction).index(next(x for x in direction if x != 0))
    return [ (i,c_i) for i, c_i in enumerate(descriptor.c) if c_i[j] == direction[j] ]
%>

% for direction in directions:
__global__ void communicate_${name(direction)}(
      ${float_type}** f_a
    , ${float_type}** f_b
    , std::size_t* cells_a
    , std::size_t* cells_b
    , std::size_t  cell_count
) {
    const std::size_t index = blockIdx.x * blockDim.x + threadIdx.x;
    if (!(index < cell_count)) {
        return;
    }
    const std::size_t gid_a = cells_a[index];
    const std::size_t gid_b = cells_b[index];

% for i, c_i in neighbors(direction):
    ${float_type}* preshifted_f_a_${i} = f_a[${i}] + ${layout.cell_preshift('gid_a')};
    ${float_type}* preshifted_f_b_${i} = f_b[${i}] + ${layout.cell_preshift('gid_b')};
% endfor

% for i, c_i in neighbors(direction):
    *preshifted_f_b_${i} = *preshifted_f_a_${i};
% endfor

% for i, c_i in neighbors(-direction):
    ${float_type}* preshifted_f_a_${i} = f_a[${i}] + ${layout.cell_preshift('gid_a')};
    ${float_type}* preshifted_f_b_${i} = f_b[${i}] + ${layout.cell_preshift('gid_b')};
% endfor

% for i, c_i in neighbors(-direction):
    *preshifted_f_a_${i} = *preshifted_f_b_${i};
% endfor
}

% endfor
