#!/usr/bin/env python

from setuptools import setup, find_packages

setup(
    name        = 'boltzgen',
    version     = '0.1',
    description = 'Symbolic generation of LBM kernels',
    author      = 'Adrian Kummerlaender',
    packages    = find_packages(),
    include_package_data = True,
    package_data = {'boltzgen': ['kernel/template/*.mako', 'kernel/template/pattern/*.mako']},
    install_requires = [
        'sympy >= 1.4',
        'numpy >= 1.17.2',
        'mako  >= 1.0.12'
    ]
)
