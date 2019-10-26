import argparse
import string

from boltzgen import *

argparser = argparse.ArgumentParser(description='Generate LBM kernels in various languages using a symbolic description.')
argparser.add_argument('language', help = 'Target language (currently either "cl" or "cpp")')
argparser.add_argument('--layout', dest = 'layout', help = 'Memory layout ("AOS" or "SOA")', required = True)
argparser.add_argument('--precision', dest = 'precision', help = 'Floating precision ("single" or "double")', required = True)

args = argparser.parse_args()

lbm = LBM(D2Q9)
generator = Generator(
    descriptor = D2Q9,
    moments    = lbm.moments(),
    collision  = lbm.bgk(f_eq = lbm.equilibrium(), tau = 0.6))

geometry = Geometry(1024,1024)

src = generator.kernel(args.language, args.precision, args.layout, geometry)
print(src)
