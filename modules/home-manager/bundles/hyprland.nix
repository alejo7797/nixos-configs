{ config, lib, ... }:

let
  cfg = config.my.hyprland;
in

{
  options = {

    my.hyprland.enable = lib.mkEnableOption "Hyprland bundle";

  };

  config = lib.mkIf cfg.enable {

    programs = {
      waybar.enable = true;
      wlogout.enable = true;
    };

    services = {
      kanshi.enable = true;
      swaync.enable = true;
      my.swww.enable = true;
    };

    wayland.windowManager.hyprland.enable = true;

  };
}
