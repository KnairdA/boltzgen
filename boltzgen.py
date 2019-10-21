import argparse
import string

from boltzgen import *

argparser = argparse.ArgumentParser(description='Generate LBM kernels in various languages using a symbolic description.')
argparser.add_argument('language', help = 'Target language (currently either "opencl" or "cpp")')

args = argparser.parse_args()

lbm = LBM(D2Q9)
geometry = Geometry(32,32)

src = source(
    args.language,
    D2Q9,
    lbm.moments(),
    lbm.bgk(f_eq = lbm.equilibrium(), tau = 0.6),
    "",
    'float',
    geometry
)

print(src)
