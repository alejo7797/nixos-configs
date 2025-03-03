{
  lib,
  config,
  pkgs,
  ...
}:

let
  cfg = config.myHome.wayland;
in

{
  options.myHome.wayland.enable = lib.mkEnableOption "Wayland";

  config = lib.mkIf cfg.enable {

    myHome = {
      graphical.enable = true;
      waybar.enable = true;
      swaync.enable = true;
    };

    # Set environment variables using UWSM.
    xdg.configFile."uwsm/env".text = ''

      # Set the cursor size.
      export XCURSOR_SIZE=24
      export HYPRCURSOR_SIZE=24

      # Wayland fixes.
      export _JAVA_AWT_WM_NONREPARENTING=1
      export QT_WAYLAND_DISABLE_WINDOWDECORATION=1

    '';

    # Stylix wants to set the wallpaper too.
    stylix.targets.hyprlock.enable = false;

    programs.hyprlock = {
      enable = true;
      settings = {
        general = {
          grace = 5; hide_cursor = true;
        };
        background = {
          path = "${config.xdg.configHome}/hypr/wall.png";
          blur_passes = 2; brightness = 0.5;
        };
        input-field = {
          fade_timeout = 1000; monitor = "";
          placeholder_text = ""; size = "400, 60";
        };
      };
    };

    programs.wofi = {
      enable = true;
      settings = {
        mode = "drun,run"; # Run commands in system $PATH.
        drun-print_command = true; run-print_command = true;
        width = "36%"; height = "40%"; allow_images = true;
        location = "center"; key_expand = "Ctrl-x";
      };
    };

    services = {
      kanshi.enable = true;

      gammastep = {
        enable = true;
        tray = true;
        provider = lib.mkDefault "geoclue2";
        settings.general = {
          fade = 1; gamma = 0.8;
          adjustment-method = "wayland";
        };
      };

      hypridle = {
        enable = true;
        settings =
          let
            hyprlock = "${pkgs.hyprlock}/bin/hyprlock";
            loginctl = "${pkgs.systemd}/bin/loginctl";
            playerctl = "${pkgs.playerctl}/bin/playerctl";
            systemctl = "${pkgs.systemd}/bin/systemctl";
          in
          {
            general = {
              lock_cmd = "${playerctl} -a pause; ${hyprlock}";
              unlock_cmd = "${pkgs.procps}/bin/pkill -USR1 hyprlock";
              before_sleep_cmd = "${loginctl} lock-session";
            };
            listener = [
              {
                timeout = 600;
                on-timeout = "${loginctl} lock-session";
              }
              {
                timeout = 720;
                on-timeout = "${systemctl} suspend";
              }
            ];
          };
      };
    };
  };
}
