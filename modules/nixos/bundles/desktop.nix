{ config, lib, ... }:

let
  cfg = config.my.desktop;
in

{
  options = {

    my.desktop.enable = lib.mkEnableOption "desktop bundle";

  };

  config = lib.mkIf cfg.enable {



  };
}
