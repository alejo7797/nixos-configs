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

  wolfram-logo = builtins.fetchurl {
    url = "https://patchoulihq.cc/wolfram-logo.png";
    sha256 = "0yr527s52fzi9q744ns3g6ak6hvncppyzijqmb7kkssvz54kf09p";
  };

  WolframLanguageForJupyter = pkgs.fetchFromGitHub {
    owner = "WolframResearch";
    repo = "WolframLanguageForJupyter";
    rev = "v0.9.3";
    hash = "sha256-aFj7FM8DuiOp47RUB3lzX26fsvy1HWlbcdAbvym10qs=";
  };
in

{
  options.myNixOS.jupyter.enable = lib.mkEnableOption "Jupyter";

  config = lib.mkIf cfg.enable {

    environment.systemPackages = with pkgs; [

      (jupyter.override {

        definitions = {

          # The default Jupyter kernel.
          inherit (jupyter-kernel.default) python3;

          # Interface with SageMath.
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

          # Interface with the Wolfram Engine.
          wolfram = {
            displayName = "Wolfram Language ${mathematica-webdoc.version}";
            argv = [
              "${mathematica-webdoc}/bin/WolframKernel"
              "-script" "${WolframLanguageForJupyter}/WolframLanguageForJupyter/Resources/KernelForWolframLanguageForJupyter.wl"
              "{connection_file}"
            ];
            language = "Wolfram Language";
            logo32 = wolfram-logo;
            logo64 = wolfram-logo;
          };

        };
      })
    ];
  };
}
