{ config, lib, pkgs, ... }:

let
  cfg = config.programs.my.jupyter;

  # TODO: remove with 25.05
  sage-logo = builtins.fetchurl {
    url = "https://raw.githubusercontent.com/sagemath/sage/refs"
      + "/heads/master/src/sage/ext_data/notebook-ipython/logo-64x64.png";
    sha256 = "sha256-pE3myKl2ywp6zDUD0JiMs+lvAk6T4O3z5PdEC/B0ZL4=";
  };
in

{
  options.programs.my.jupyter.enable = lib.mkEnableOption "Jupyter";

  config = lib.mkIf cfg.enable {

    environment.systemPackages = with pkgs; [

      (jupyter.override {

        definitions = {

          # The default Jupyter Python interpreter.
          inherit (jupyter-kernel.default) python3;

          # Wolfram Language kernel for Jupyter.
          wolfram = (wolfram-for-jupyter-kernel.override {
            wolfram-engine = mathematica-webdoc;
          }).definition // {
            logo32 = "${mathematica-webdoc}/share/icons/hicolor/32x32/apps/wolfram-wolfram.png";
            logo64 = "${mathematica-webdoc}/share/icons/hicolor/64x64/apps/wolfram-wolfram.png";
          };

          # SageMath Jupyter kernel.
          sagemath = sage.kernelspec // {
            logo32 = sage-logo;
            logo64 = sage-logo;
          };

        };
      })
    ];
  };
}
