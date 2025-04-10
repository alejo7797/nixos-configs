{ config, lib, pkgs, ... }:

let
  cfg = config.my.math;
  yaml = pkgs.formats.yaml { };
in

{
  options.my.math.enable = lib.mkEnableOption "math bundle";

  config = lib.mkIf cfg.enable {

    home.sessionVariables = {
      DOT_SAGE = "${config.xdg.configHome}/sage";
      MATHEMATICA_USERBASE = "${config.xdg.dataHome}/WolframEngine";
      WOLFRAM_USERBASE = "${config.xdg.dataHome}/Wolfram";

      # TODO: default in Jupyter6
      JUPYTER_PLATFORM_DIRS = 1;
    };

    xdg.configFile = {
      # Set LaTeX environments for chktex to ignore.
      "chktexrc".source = ../programs/latex/chktexrc;

      # Set some basic options, add support for Asymptote files.
      "latexmk/latexmkrc".source = ../programs/latex/latexmkrc;

      "latexindent/latexindent.yaml".source = ../programs/latex/latexindent;
      "latexindent/indentconfig.yaml".source = yaml.generate "indentconfig.yaml" {
        paths = [ "${config.xdg.configHome}/latexindent/latexindent.yaml" ];
      };
    };

  };
}
