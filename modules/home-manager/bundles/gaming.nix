{ config, lib, ... }:

let
  cfg = config.my.gaming;
in

{
  options.my.gaming.enable = lib.mkEnableOption "gaming bundle";

  config = lib.mkIf cfg.enable {

    home.sessionVariables = {
      RENPY_PATH_TO_SAVES = "${config.xdg.dataHome}/renpy";
    };

  };
}
