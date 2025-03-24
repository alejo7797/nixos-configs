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
      hyprlock.enable = true;
      waybar.enable = true;
      wlogout.enable = true;
      wofi.enable = true;
    };

    services = {
      gammastep.enable = true;
      hypridle.enable = true;
      kanshi.enable = true;
      swaync.enable = true;
      my.swww.enable = true;
    };

    wayland.windowManager.hyprland.enable = true;

  };
}
