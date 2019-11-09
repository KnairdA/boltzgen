# boltzgen

…a framework for symbolically generating optimized implementations of the Lattice Boltzmann Method.

At the moment this is a more structured and cleaned up version of the OpenCL kernel generator employed by [symlbm_playground](https://tree.kummerlaender.eu/projects/symlbm_playground/). The goal is to build upon this foundation to provide an easy way to generate efficient code using a high level description of various collision models and boundary conditions. This should allow for easy comparision between various streaming patterns and memory layouts.

## Features

* BGK collision step
* D2Q9, D3Q7, D3Q19 and D3Q27 lattices with automatic weight inference
* momenta and bounce back boundary conditions
* equilibrilization and moment collection utility functions
* optimization via common subexpression elimination
* array-of-structures and structure-of-arrays memory layouts
* configurable cell indexing sequence
* static resolution of memory offsets
* AB, AA and SSS streaming patterns
* C++ and OpenCL targets
* simple CLI frontend

## Usage

The development and execution environment is described using a Nix expression in `shell.nix`.

```
> nix-shell
> ./boltzgen.py --help
usage: boltzgen.py [-h] --lattice LATTICE [--model MODEL] --precision
                   PRECISION --layout LAYOUT [--index INDEX] --streaming
                   STREAMING --geometry GEOMETRY --tau TAU [--disable-cse]
                   [--functions FUNCTIONS [FUNCTIONS ...]]
                   [--extras EXTRAS [EXTRAS ...]]
                   target

Generate LBM kernels in various languages using a symbolic description.

positional arguments:
  target                Target language (currently either "cl" or "cpp")

optional arguments:
  -h, --help            show this help message and exit
  --lattice LATTICE     Lattice type ("D2Q9", "D3Q7", "D3Q19", "D3Q27")
  --model MODEL         LBM model (currently only "BGK")
  --precision PRECISION
                        Floating precision ("single" or "double")
  --layout LAYOUT       Memory layout ("AOS" or "SOA")
  --index INDEX         Cell indexing ("XYZ" or "ZYX")
  --streaming STREAMING
                        Streaming pattern ("AB" or "AA")
  --geometry GEOMETRY   Size of the block geometry ("x:y(:z)")
  --tau TAU             BGK relaxation time
  --disable-cse         Disable common subexpression elimination
  --functions FUNCTIONS [FUNCTIONS ...]
                        Function templates to be generated
  --extras EXTRAS [EXTRAS ...]
                        Additional generator parameters

> ./boltzgen.py cpp --lattice D2Q9
\                   --geometry 128:128
\                   --precision double
\                   --streaming AB
\                   --layout AOS
\                   --tau 0.52
\                   --functions default bounce_back_boundary | tee kernel.h
void collide_and_stream(      double* f_next,
                        const double* f_prev,
                        std::size_t gid)
{
          double* preshifted_f_next = f_next + gid*9;
    const double* preshifted_f_prev = f_prev + gid*9;

    const double f_curr_0 = preshifted_f_prev[1161];
    const double f_curr_1 = preshifted_f_prev[1153];
    const double f_curr_2 = preshifted_f_prev[1145];
    const double f_curr_3 = preshifted_f_prev[12];
    const double f_curr_4 = preshifted_f_prev[4];
[...]
```

For some examples on how to actually run the generated code see [boltzgen_examples](https://github.com/KnairdA/boltzgen_examples).
