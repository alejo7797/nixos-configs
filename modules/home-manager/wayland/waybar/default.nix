{ pkgs, lib, config, ... }: let

  cfg = config.myHome.waybar;

in {

  imports = [ ./modules.nix ];

  options.myHome.waybar = {

    enable = lib.mkEnableOption "waybar";

    thermal-zone = lib.mkOption {
      description = "Thermal zone to monitor in waybar.";
      type = lib.types.int;
      default = 2;
    };

    wttr-location = lib.mkOption {
      description = "Location to show the weather for in waybar.";
      type = lib.types.str;
      default = "Madrid";
    };

  };

  config = lib.mkIf cfg.enable {

    # Style waybar ourselves.
    stylix.targets.waybar.enable = false;

    # For the weather indicator.
    home.packages = [ pkgs.wttrbar ];

    # Install and configure waybar.
    programs.waybar = {

      enable = true;
      systemd.enable = true;

      style = ./style.css;

      settings.mainBar = {

        position = "bottom";
        height = 30;
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
  };
}
