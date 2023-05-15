{
  description = "w2dynamics: A continuous-time hybridization-expansion Monte Carlo code for calculating n-particle Green's functions of the Anderson impurity model and within dynamical mean-field theory.";

  nixConfig = {
    extra-experimental-features = "nix-command flakes";
    extra-substituters = "https://diagmc.cachix.org";
    extra-trusted-public-keys = "diagmc.cachix.org-1:tMCq6tXbeeHnn8hA1l7h0B1WzVyAPzqAI9GgxvQimVM=";
  };

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    flake-compat = {
      url = "github:edolstra/flake-compat";
      flake = false;
    };
  };

  outputs = inputs: inputs.flake-utils.lib.eachDefaultSystem (system:
    let
      pkgs = import inputs.nixpkgs { inherit system; };
      hdf5 = pkgs.hdf5.override { fortranSupport = true; };
      nfft = pkgs.callPackage ./nfft.nix { };
      w2dynamics = pkgs.callPackage ./w2dynamics.nix { inherit hdf5 nfft; };
    in
    {
      packages.nfft = nfft;
      packages.w2dynamics = w2dynamics;
      devShells.default = pkgs.mkShell {
        buildInputs = with pkgs; [
          blas
          hdf5
          hdf5.dev
          fftw
          fftw.dev
          mpi
          nfft
          (python3.withPackages (ps: with ps; [
            numpy
            scipy
            h5py
            mpi4py
            configobj
          ]))
        ];
        nativeBuildInputs = with pkgs; [
          cmake
          ninja
          gcc
          gdb
          gfortran
          pkgconfig
          valgrind
        ];
        shellHook = ''
          NFFT_PATH=${nfft}
        '';
      };
      formatter = pkgs.nixpkgs-fmt;
    });
}
