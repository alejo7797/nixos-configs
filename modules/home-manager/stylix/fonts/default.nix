{ config, lib, ... }:

let
  cfg = config.fonts.fontconfig;
in

lib.mkIf cfg.enable {

  xdg.configFile."fontconfig/conf.d" = {
    source = ./conf.d; recursive = true;
  };

}
