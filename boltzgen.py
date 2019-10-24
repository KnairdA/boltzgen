import argparse
import string

from boltzgen import *

argparser = argparse.ArgumentParser(description='Generate LBM kernels in various languages using a symbolic description.')
argparser.add_argument('language', help = 'Target language (currently either "opencl" or "cpp")')
argparser.add_argument(
    '--layout', dest = 'layout',
    help = 'Memory layout ("aos" or "soa" for C++, ignored for OpenCL')

args = argparser.parse_args()

if args.language == 'cpp' and args.layout is None:
    raise Exception('Please specify the memory layout')

lbm = LBM(D2Q9)
generator = Generator(
    descriptor = D2Q9,
    moments    = lbm.moments(),
    collision  = lbm.bgk(f_eq = lbm.equilibrium(), tau = 0.6))

geometry = Geometry(1024,1024)

src = generator.kernel(args.language, 'double', args.layout, geometry)
print(src)
