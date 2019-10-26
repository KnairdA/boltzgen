import argparse
import string

from boltzgen import *

argparser = argparse.ArgumentParser(
    description = 'Generate LBM kernels in various languages using a symbolic description.')

argparser.add_argument('language', help = 'Target language (currently either "cl" or "cpp")')

argparser.add_argument('--lattice',   dest = 'lattice',   required = True, help = 'Lattice type (D2Q9, D3Q7, D3Q19, D3Q27)')
argparser.add_argument('--layout',    dest = 'layout',    required = True, help = 'Memory layout ("AOS" or "SOA")')
argparser.add_argument('--precision', dest = 'precision', required = True, help = 'Floating precision ("single" or "double")')

args = argparser.parse_args()

lattice = eval("lbm.model.%s" % args.lattice)

lbm = LBM(lattice)
generator = Generator(
    descriptor = lattice,
    moments    = lbm.moments(),
    collision  = lbm.bgk(f_eq = lbm.equilibrium(), tau = 0.6))

geometry = Geometry(1024,1024)

src = generator.kernel(args.language, args.precision, args.layout, geometry)
print(src)
