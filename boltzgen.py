#!/usr/bin/env python

import argparse
from boltzgen import *

argparser = argparse.ArgumentParser(
    description = 'Generate LBM kernels in various languages using a symbolic description.')

argparser.add_argument('target', help = 'Target language (currently either "cl" or "cpp")')

argparser.add_argument('--lattice',   required = True,  help = 'Lattice type ("D2Q9", "D3Q7", "D3Q19", "D3Q27")')
argparser.add_argument('--model',     required = False, help = 'LBM model (currently only "BGK")')
argparser.add_argument('--precision', required = True,  help = 'Floating precision ("single" or "double")')
argparser.add_argument('--layout',    required = True,  help = 'Memory layout ("AOS" or "SOA")')
argparser.add_argument('--index',     required = False, help = 'Cell indexing ("XYZ" or "ZYX")')
argparser.add_argument('--streaming', required = True,  help = 'Streaming pattern ("AB", "AA" or "SSS")')
argparser.add_argument('--geometry',  required = True,  help = 'Size of the block geometry ("x:y(:z)")')
argparser.add_argument('--tau',       required = True,  help = 'BGK relaxation time')

argparser.add_argument('--disable-cse', action = 'store_const', const = True, help = 'Disable common subexpression elimination')
argparser.add_argument('--functions',   action = 'append', nargs = '+', default = [], help = 'Function templates to be generated')
argparser.add_argument('--extras',      action = 'append', nargs = '+', default = [], help = 'Additional generator parameters')

args = argparser.parse_args()

if args.model is None:
    args.model = "BGK"

if args.index is None:
    args.index = 'XYZ'

try:
    lattice = eval("lbm.lattice.%s" % args.lattice)
except AttributeError:
    raise Exception("There is no lattice type called '%s'" % args.lattice) from None

try:
    model = eval("lbm.model.%s" % args.model)
except AttributeError:
    raise Exception("There is no LBM model called '%s'" % args.model) from None

generator = Generator(
    model      = model(lattice, tau = float(args.tau), optimize = not args.disable_cse),
    target     = args.target,
    precision  = args.precision,
    streaming  = args.streaming,
    index      = args.index,
    layout     = args.layout)

geometry = Geometry.parse(args.geometry)

functions = sum(args.functions, [])
if len(functions) == 0:
    functions += ['default']
if 'default' in functions:
    for f in ['collide', 'equilibrilize', 'collect_moments', 'momenta_boundary']:
        functions.insert(functions.index('default'), f)
    functions.remove('default')

extras = sum(args.extras, [])

src = generator.kernel(geometry, functions, extras)
print(src)
