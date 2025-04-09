{ config, lib, ... }:

let
  cfg = config.my.math;
in

{
  options.my.math.enable = lib.mkEnableOption "math bundle";

  config = lib.mkIf cfg.enable {

    home.sessionVariables = {
      DOT_SAGE = "${config.xdg.configHome}/sage";
      MATHEMATICA_USERBASE = "${config.xdg.dataHome}/WolframEngine";
      WOLFRAM_USERBASE = "${config.xdg.dataHome}/Wolfram";

      # TODO: default for Jupyter 6
      JUPYTER_PLATFORM_DIRS = 1;
    };

  };
}
