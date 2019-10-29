#!/usr/bin/env python

import argparse
from boltzgen import *

argparser = argparse.ArgumentParser(
    description = 'Generate LBM kernels in various languages using a symbolic description.')

argparser.add_argument('language', help = 'Target language (currently either "cl" or "cpp")')

argparser.add_argument('--lattice',   required = True,  help = 'Lattice type (D2Q9, D3Q7, D3Q19, D3Q27)')
argparser.add_argument('--layout',    required = True,  help = 'Memory layout ("AOS" or "SOA")')
argparser.add_argument('--indexing',  required = False, help = 'Cell indexing ("XYZ" or "ZYX")')
argparser.add_argument('--precision', required = True,  help = 'Floating precision ("single" or "double")')
argparser.add_argument('--geometry',  required = True,  help = 'Size of the block geometry ("x:y(:z)")')
argparser.add_argument('--tau',       required = True,  help = 'BGK relaxation time')

argparser.add_argument('--disable-cse', action = 'store_const', const = True, help = 'Disable common subexpression elimination')
argparser.add_argument('--functions',   action = 'append', nargs = '+', default = [], help = 'Function templates to be generated')
argparser.add_argument('--extras',      action = 'append', nargs = '+', default = [], help = 'Additional generator parameters')

args = argparser.parse_args()

lattice = eval("lbm.model.%s" % args.lattice)

lbm = LBM(lattice)
generator = Generator(
    descriptor = lattice,
    moments    = lbm.moments(optimize = not args.disable_cse),
    collision  = lbm.bgk(f_eq = lbm.equilibrium(), tau = float(args.tau), optimize = not args.disable_cse))

if args.indexing is None:
    args.indexing = 'XYZ'

geometry = Geometry.parse(args.geometry)

functions = sum(args.functions, [])
if len(functions) == 0:
    functions += ['default']
if 'default' in functions:
    for f in ['collide_and_stream', 'equilibrilize', 'collect_moments', 'momenta_boundary']:
        functions.insert(functions.index('default'), f)
    functions.remove('default')

extras = sum(args.extras, [])

src = generator.kernel(args.language, args.precision, args.layout, args.indexing, geometry, functions, extras)
print(src)
