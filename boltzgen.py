#!/usr/bin/env python

import argparse
from boltzgen import *

argparser = argparse.ArgumentParser(
    description = 'Generate LBM kernels in various languages using a symbolic description.')

argparser.add_argument('language', help = 'Target language (currently either "cl" or "cpp")')

argparser.add_argument('--lattice',   required = True, help = 'Lattice type (D2Q9, D3Q7, D3Q19, D3Q27)')
argparser.add_argument('--layout',    required = True, help = 'Memory layout ("AOS" or "SOA")')
argparser.add_argument('--precision', required = True, help = 'Floating precision ("single" or "double")')
argparser.add_argument('--geometry',  required = True, help = 'Size of the block geometry ("x:y(:z)")')
argparser.add_argument('--tau',       required = True, help = 'BGK relaxation time')

argparser.add_argument('--disable-cse', action = 'store_const', const = True, help = 'Disable common subexpression elimination')

args = argparser.parse_args()

lattice = eval("lbm.model.%s" % args.lattice)

lbm = LBM(lattice)
generator = Generator(
    descriptor = lattice,
    moments    = lbm.moments(optimize = not args.disable_cse),
    collision  = lbm.bgk(f_eq = lbm.equilibrium(), tau = float(args.tau), optimize = not args.disable_cse))

geometry = Geometry.parse(args.geometry)

src = generator.kernel(args.language, args.precision, args.layout, geometry)
print(src)
