{ config, lib, pkgs, ... }:

let
  cfg = config.programs.waybar;
in

{
  options.programs.waybar = {

    my.thermal-zone = lib.mkOption {
      description = "Thermal zone to monitor in waybar.";
      type = lib.types.int;
      default = 2;
    };

    my.location = lib.mkOption {
      description = "Weather location to use in waybar.";
      type = lib.types.str;
      default = "Madrid";
    };
  };

  config = lib.mkIf cfg.enable {

    # Set the style for waybar ourselves.
    stylix.targets.waybar.enable = false;

    programs.waybar = {

      # Run as a user service.
      systemd.enable = true;

      style = ./style.css;

      settings.mainBar = {
        height = 32; spacing = 5;
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

    systemd.user.services = {
      waybar = {
        # https://github.com/nix-community/home-manager/pull/6675
        Unit.PartOf = [ "tray.target" ];
        Install.WantedBy = [ "tray.target" ];
      };

      # This seems like an story in active development.
      # For now, see https://github.com/Alexays/Waybar/issues/2437.
      waybar-tray-init-shim = {
        Unit = {
          Description = "Wait for org.kde.StatusNotifierWatcher to appear in the system bus";
          ConditionEnvironment = "WAYLAND_DISPLAY"; After = [ "waybar.service" ];
        };
        Service = {
          Type = "oneshot";
          ExecStart = pkgs.writeShellScript "wait-for-status-notifier" ''

            while ! dbus-send --session --dest=org.freedesktop.DBus --type=method_call \
                              --print-reply /org/freedesktop/DBus org.freedesktop.DBus.ListNames |\
                    grep org.kde.StatusNotifierWatcher

            do sleep 0.1; done

          '';
        };
        Install.WantedBy = [ "tray.target" ];
      };
    };
  };
}
