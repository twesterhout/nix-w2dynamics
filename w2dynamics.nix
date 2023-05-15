{ blas
, cmake
, fetchFromGitHub
, fftw
, hdf5
, gcc
, gfortran
, lib
, mpi
, nfft
, pkgconfig
, python3
, stdenv
}:

stdenv.mkDerivation {
  pname = "w2dynamics";
  version = "1.1.3";
  src = fetchFromGitHub {
    owner = "w2dynamics";
    repo = "w2dynamics";
    rev = "d02d8c9973fec34540061ea3ec5705bbd25bdc5b";
    hash = "sha256-Q1NxvydZpstgHfFcozkRVsaoLFM17EuHw0Q37C8VUKQ=";
  };

  doCheck = true;

  buildInputs = [
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

  nativeBuildInputs = [
    cmake
    gcc
    gfortran
    pkgconfig
  ];

  meta = with lib; {
    description = "w2dynamics - Wien/Wuerzburg strong coupling solver";
    homepage = "https://github.com/w2dynamics/w2dynamics";
    license = licenses.gpl3;
    platforms = platforms.linux;
  };
}
