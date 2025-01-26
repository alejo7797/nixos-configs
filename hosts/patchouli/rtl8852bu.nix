{
  lib,
  stdenv,
  kernel,
}:

let
  modDir = "lib/modules/${kernel.modDirVersion}";
in 

stdenv.mkDerivation rec {

  name = "rtl8852bu";

  src = builtins.fetchurl {
    url = "https://linux.brostrend.com/${name}-dkms.deb";
    sha256 = "0bh9sgixdlgbhfblbnvb2bys34mclpgcmmn1cl5nby9268757m3h";
  };

  hardeningDisable = [ "pic" "format" ];
  nativeBuildInputs = kernel.moduleBuildDependencies;

  unpackCmd = ''
    ar x $curSrc
    tar xf data.tar.gz
  '';

  setSourceRoot = ''
    sourceRoot=$(echo usr/src/${name}-*)
  '';

  patchPhase = ''
    substituteInPlace Makefile --replace-fail "/sbin/depmod" "# depmod"
  '';

  configurePhase = ''
    export src=$(pwd)
  '';

  preBuild = ''
    mkdir -p $out/${modDir}
  '';

  makeFlags = [
    "KSRC=${kernel.dev}/${modDir}/build" "MODDESTDIR=$out/${modDir}"
  ];

  meta = {
    description = "A kernel module for the Brostrend AX4L USB WiFi adapter";
    homepage = "https://linux.brostrend.com";
    license = lib.licenses.gpl2;
    platforms = lib.platforms.linux;
  };

}
