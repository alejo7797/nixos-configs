{ config, lib, pkgs, ... }:

let
  cfg = config.programs.my.jupyter;
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
            logo32 = "${mathematica-webdoc}/share/icons/hicolor/32x32/apps/wolfram-wolfram-14.2.png";
            logo64 = "${mathematica-webdoc}/share/icons/hicolor/64x64/apps/wolfram-wolfram-14.2.png";
          };

          # SageMath Jupyter kernel.
          sagemath = sage.kernelspec;

        };
      })
    ];
  };
}
