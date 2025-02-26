{
  lib,
  config,
  pkgs,
  ...
}:

let
  cfg = config.myNixOS.jupyter;

  sage-logo = builtins.fetchurl {
    url = "https://patchoulihq.cc/sage-logo.png";
    sha256 = "1gk4fkq0ni7pwkryvq4k9q16zsdkijcd00rmrix0mjvnm74fckd4";
  };
in

{
  options.myNixOS.jupyter.enable = lib.mkEnableOption "Jupyter";

  config = lib.mkIf cfg.enable {

    environment.systemPackages = with pkgs; [

      (jupyter.override {

        definitions = {

          # The default Python 3 interactive shell.
          inherit (jupyter-kernel.default) python3;

          # Interface with the Wolfram Engine.
          wolfram = wolfram-for-jupyter-kernel.definition;

          sagemath = {
            displayName = "SageMath ${sage.version}";
            argv = [
              "${sage}/bin/sage" "--python"
              "-m" "sage.repl.ipython_kernel"
              "-f" "{connection_file}"
            ];
            language = "sage";
            logo32 = sage-logo;
            logo64 = sage-logo;
          };

        };
      })
    ];
  };
}
