{
  lib,
  config,
  ...
}:

let
  cfg = config.myHome.waybar;
in

{
  options.myHome.waybar = {

    enable = lib.mkEnableOption "waybar";

    thermal-zone = lib.mkOption {
      description = "Thermal zone to monitor in waybar.";
      type = lib.types.int;
      default = 2;
    };

    location = lib.mkOption {
      description = "Weather location to use in waybar.";
      type = lib.types.str;
      default = "Madrid";
    };
  };

  config = lib.mkIf cfg.enable {

    # Set the style for waybar ourselves.
    stylix.targets.waybar.enable = false;

    programs.waybar = {
      enable = true;

      # Run as a user service.
      systemd.enable = true;

      style = ./style.css;

      settings.mainBar = {
        # The one and only bar.
        height = 30; spacing = 5;
        position = "bottom";

        modules-left = [ "hyprland/workspaces" ];

        modules-right = [
          "idle_inhibitor" "systemd-failed-units"
          "pulseaudio" "cpu" "memory" "disk" "battery"
          "network" "network#vpn" "network#harvard"
          "custom/wttr" "clock" "custom/swaync" "tray"
        ];
      };
    };

    systemd.user.services.waybar = {
      Unit.PartOf = [ "tray.target" ];
      Install.WantedBy = [ "tray.target" ];
    };
  };
}
