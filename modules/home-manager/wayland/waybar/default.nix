{ pkgs, lib, config, ... }: {

  imports = [ ./modules.nix ];

  # Style waybar ourselves.
  stylix.targets.waybar.enable = false;

  # Module dependencies.
  home.packages =
    lib.optionals (config.myHome.hostname == "shinobu")
    [ pkgs.wttrbar ];

  # Install and configure waybar.
  programs.waybar = {

    enable = true;
    systemd.enable = true;

    style = ./style.css;

    settings.mainBar = {

      position = "bottom";
      spacing = 5;

      modules-left = [
        "hyprland/workspaces"
        "hyprland/submap"
        "sway/workspaces"
        "sway/mode"
        "sway/scratchpad"
      ];

      modules-right = [
        "idle_inhibitor"
        "pulseaudio"
        "cpu"
        "memory"
        "disk"
        "battery"
        "temperature"
        "network"
        "network#vpn"
        "network#harvard"
        "custom/weather"
        "clock"
        "custom/swaync"
        "tray"
      ];
    };
  };
}
