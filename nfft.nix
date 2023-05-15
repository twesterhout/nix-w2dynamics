{ autoconf
, automake
, libtool
, fetchFromGitHub
, fftw
, gcc
, lib
, stdenv
}:

stdenv.mkDerivation rec {
  pname = "nfft";
  version = "3.5.3";
  src = fetchFromGitHub {
    owner = "NFFT";
    repo = "nfft";
    rev = version;
    hash = "sha256-HR8ME9PVC+RAv1GIgV2vK6eLU8Wk28+rSzbutThBv3w=";
  };

  patchPhase = ''
    patchShebangs bootstrap.sh
  '';

  configurePhase = ''
    ./bootstrap.sh
    ./configure --prefix=$out --enable-all --enable-openmp --with-gcc-arch=nehalem
  '';

  installPhase = ''
    make install
  '';

  buildInputs = [
    fftw.dev
  ];

  nativeBuildInputs = [
    gcc
    libtool
    autoconf
    automake
  ];

  meta = {
    description = "NFFT - Nonequispaced FFT";
    homepage = "https://tu-chemnitz.de/~potts/nfft/";
  };
}
