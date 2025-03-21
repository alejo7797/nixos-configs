{ config, lib, ... }:

let
  cfg = config.my.hyprland;
in

{
  options = {

    my.hyprland.enable = lib.mkEnableOption "Hyprland bundle";

  };

  config = lib.mkIf cfg.enable {

    # TODO: migrate
    myHome.hyprland.enable = true;

    programs = {
      waybar.enable = true;
    };

    services = {
      my.swww.enable = true;
    };

  };
}
