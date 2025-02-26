{
  lib,
  config,
  pkgs,
  ...
}:

let
  cfg = config.myNixOS.jupyter;

  sage-logo = builtins.fetchurl {
    url = "https://raw.githubusercontent.com/sagemath/sage/refs"
      + "/heads/master/src/sage/ext_data/notebook-ipython/logo-64x64.png";
    sha256 = "sha256-pE3myKl2ywp6zDUD0JiMs+lvAk6T4O3z5PdEC/B0ZL4=";
  };
in

{
  options.myNixOS.jupyter.enable = lib.mkEnableOption "Jupyter";

  config = lib.mkIf cfg.enable {

    environment.systemPackages = with pkgs; [

      (jupyter.override {

        definitions = {

          # The default Python 3 interpreter.
          inherit (jupyter-kernel.default) python3;

          # Wolfram Language kernel for Jupyter.
          wolfram = wolfram-for-jupyter-kernel.definition;

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
