{
  lib, fetchurl,
  stdenv, kernel,
}:

let
  modDir = "lib/modules/${kernel.modDirVersion}";
in

stdenv.mkDerivation rec {

  name = "rtl8852bu";

  src = fetchurl {
    url = "https://linux.brostrend.com/${name}-dkms.deb";
    sha256 = "sha256-Y3WSTmB/R5554cn9Fql8FfcJFkZhe+2yT5ZvA0QEo5I=";
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

  postPatch = ''
    substituteInPlace core/rtw_debug.c \
      --replace-fail "RTW_PRINT_SEL(sel, \"build time: %s %s\n\", __DATE__, __TIME__);" ""
  '';

  preBuild = ''
    export src=$(pwd)
  '';

  makeFlags = [
    "KSRC=${kernel.dev}/${modDir}/build"
  ];

  installPhase = ''
    install -Dm644 ${lib.removePrefix "rtl" name}.ko -t $out/${modDir}
  '';

  meta = {
    description = "Kernel module for the Brostrend AX4L USB WiFi adapter";
    homepage = "https://linux.brostrend.com";
    license = lib.licenses.gpl2;
    platforms = lib.platforms.linux;
  };

}
