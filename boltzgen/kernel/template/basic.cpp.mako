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

void collide_and_stream(      ${float_type}* f_next,
                        const ${float_type}* f_prev,
                        std::size_t gid)
{
          ${float_type}* preshifted_f_next = f_next + gid*${layout.gid_offset()};
    const ${float_type}* preshifted_f_prev = f_prev + gid*${layout.gid_offset()};

% for i, c_i in enumerate(descriptor.c):
    const ${float_type} f_curr_${i} = preshifted_f_prev[${layout.pop_offset(i) + layout.neighbor_offset(-c_i)}];
% endfor

% for i, expr in enumerate(moments_subexpr):
    const ${float_type} ${expr[0]} = ${ccode(expr[1])};
% endfor

% for i, expr in enumerate(moments_assignment):
    ${float_type} ${ccode(expr)}
% endfor

% for i, expr in enumerate(collision_subexpr):
    const ${float_type} ${expr[0]} = ${ccode(expr[1])};
% endfor

% for i, expr in enumerate(collision_assignment):
    const ${float_type} ${ccode(expr)}
% endfor

% for i, expr in enumerate(collision_assignment):
    preshifted_f_next[${layout.pop_offset(i)}] = f_next_${i};
% endfor
}

void collect_moments(const ${float_type}* f,
                     std::size_t gid,
                     ${float_type}& rho,
                     ${float_type} u[${descriptor.d}])
{
    const ${float_type}* preshifted_f = f + gid*${layout.gid_offset()};

% for i in range(0,descriptor.q):
    const ${float_type} f_curr_${i} = preshifted_f[${layout.pop_offset(i)}];
% endfor

% for i, expr in enumerate(moments_subexpr):
    const ${float_type} ${expr[0]} = ${ccode(expr[1])};
% endfor

% for i, expr in enumerate(moments_assignment):
%   if i == 0:
    rho = ${ccode(expr.rhs)};
%   else:
    u[${i-1}] = ${ccode(expr.rhs)};
%   endif
% endfor
}

void test(std::size_t nStep)
{
    auto f_a = std::make_unique<${float_type}[]>(${geometry.volume*descriptor.q + 2*layout.padding()});
    auto f_b = std::make_unique<${float_type}[]>(${geometry.volume*descriptor.q + 2*layout.padding()});
    auto material = std::make_unique<int[]>(${geometry.volume});

    // buffers are padded by maximum neighbor overreach to prevent invalid memory access
    ${float_type}* f_prev = f_a.get() + ${layout.padding()};
    ${float_type}* f_next = f_b.get() + ${layout.padding()};

    for (int iX = 0; iX < ${geometry.size_x}; ++iX) {
        for (int iY = 0; iY < ${geometry.size_y}; ++iY) {
            for (int iZ = 0; iZ < ${geometry.size_z}; ++iZ) {
                if (iX == 0 || iY == 0 || iZ == 0 ||
                    iX == ${geometry.size_x-1} || iY == ${geometry.size_y-1} || iZ == ${geometry.size_z-1}) {
                    material[iX*${geometry.size_y*geometry.size_z} + iY*${geometry.size_z} + iZ] = 0;
                } else {
                    material[iX*${geometry.size_y*geometry.size_z} + iY*${geometry.size_z} + iZ] = 1;
                }
            }
        }
    }

    std::vector<std::size_t> bulk;
    std::vector<std::size_t> bc;

    for (std::size_t iCell = 0; iCell < ${geometry.volume}; ++iCell) {
        if (material[iCell] == 0) {
            bc.emplace_back(iCell);
        }
        if (material[iCell] == 1) {
            bulk.emplace_back(iCell);
        }
    }

    for (std::size_t iCell = 0; iCell < ${geometry.volume}; ++iCell) {
        equilibrilize(f_prev, f_next, iCell);
    }

    const auto start = std::chrono::high_resolution_clock::now();

    for (std::size_t iStep = 0; iStep < nStep; ++iStep) {
        if (iStep % 2 == 0) {
            f_next = f_a.get();
            f_prev = f_b.get();
        } else {
            f_next = f_b.get();
            f_prev = f_a.get();
        }

        for (std::size_t i = 0; i < bulk.size(); ++i) {
            collide_and_stream(f_next, f_prev, bulk[i]);
        }
        for (std::size_t i = 0; i < bc.size(); ++i) {
            equilibrilize(f_next, f_prev, bc[i]);
        }
    }

    auto duration = std::chrono::duration_cast<std::chrono::duration<double>>(
        std::chrono::high_resolution_clock::now() - start);

    std::cout << "MLUPS: " << nStep*${geometry.volume}/(1e6*duration.count()) << std::endl;

    // calculate average rho as a basic quality check
    double rho_sum = 0.0;

    for (std::size_t i = 0; i < ${geometry.volume*descriptor.q}; ++i) {
        rho_sum += f_next[i];
    }

    std::cout << "avg rho: " << rho_sum/${geometry.volume} << std::endl;
}
