{ config, lib, pkgs, ... }:

let
  cfg = config.my.hyprland;
in

{
  options.my.hyprland.enable = lib.mkEnableOption "Hyprland bundle";

  config = lib.mkIf cfg.enable {

    home-manager.sharedModules = [
      { my.hyprland.enable = true; }
    ];

    environment.variables.NIXOS_OZONE_WL = 1;

    i18n.inputMethod.fcitx5 = {
      waylandFrontend = true;
    };

    security.pam = {
      services.hyprlock = { };
    };

    programs.hyprland = {
      enable = true;
      withUWSM = true;
    };

    environment.systemPackages = with pkgs; [
      grimblast
      wf-recorder
      wl-clipboard
      libsForQt5.qt5.qtwayland
      kdePackages.qtwayland
    ];
  };
}
