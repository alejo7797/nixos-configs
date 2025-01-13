{
  lib,
  config,
  pkgs,
  ...
}:

let
  cfg = config.myNixOS.jupyter;
in

{
  options.myNixOS.jupyter.enable = lib.mkEnableOption "Jupyter";

  config.services.jupyter = lib.mkIf cfg.enable {

    enable = true;
    command = "jupyter lab";

    kernels = {

      # The default Jupyter kernel.
      inherit (pkgs.jupyter-kernel.default) python3;

      # Interface with SageMath.
      sagemath = {
        displayName = "SageMath ${pkgs.sage.version}";
        argv = [
          "${pkgs.sage}/bin/sage"
          "--python"
          "-m"
          "sage.repl.ipython_kernel"
          "-f"
          "{connection_file}"
        ];
        language = "sage";
      };

      # Interface with the Wolfram Mathematica kernel.
      wolfram = pkgs.wolfram-for-jupyter-kernel.definition;

    };
  };
}
