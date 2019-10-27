{ pkgs ? import <nixpkgs> { }, ... }:

pkgs.stdenvNoCC.mkDerivation rec {
  name = "boltzgen-env";
  env = pkgs.buildEnv { name = name; paths = buildInputs; };

  buildInputs = let
    local-python = pkgs.python3.withPackages (python-packages: with python-packages; [
      numpy
      sympy
      Mako
    ]);

  in [
    local-python
    pkgs.universal-ctags
  ];

  shellHook = ''
    export NIX_SHELL_NAME="${name}"
    export PYTHONPATH="$PWD/boltzgen:$PYTHONPATH"
    export PYTHONDONTWRITEBYTECODE=1
  '';
}
