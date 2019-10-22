import argparse
import string

from boltzgen import *

argparser = argparse.ArgumentParser(description='Generate LBM kernels in various languages using a symbolic description.')
argparser.add_argument('language', help = 'Target language (currently either "opencl" or "cpp")')

args = argparser.parse_args()

lbm = LBM(D2Q9)
generator = Generator(
    descriptor = D2Q9,
    moments    = lbm.moments(),
    collision  = lbm.bgk(f_eq = lbm.equilibrium(), tau = 0.6))

geometry = Geometry(32,32)

src = generator.kernel(args.language, 'float', geometry)
print(src)
