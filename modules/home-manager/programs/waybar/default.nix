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

    systemd.user.services = {
      kdeconnect-indicator = {
        Unit.After = [ "tray.target" ];
      };

      waybar = {
        Unit.PartOf = [ "tray.target" ];
        Install.WantedBy = [ "tray.target" ];
      };

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
