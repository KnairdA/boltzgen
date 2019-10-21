from boltzgen import *

lbm = LBM(D2Q9)
geometry = Geometry(32,32)

src = source(
    'opencl',
    D2Q9,
    lbm.moments(),
    lbm.bgk(f_eq = lbm.equilibrium(), tau = 0.6),
    "",
    'float',
    geometry
)

print(src)
