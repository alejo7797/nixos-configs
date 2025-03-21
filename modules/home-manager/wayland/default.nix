{
  lib,
  config,
  pkgs,
  ...
}:

let
  cfg = config.my.wayland;
in

{
  options.my.wayland.enable = lib.mkEnableOption "Wayland";

  config = lib.mkIf cfg.enable {

    # Set environment variables using UWSM.
    xdg.configFile."uwsm/env".text = ''

      # TODO: remove with 25.05.
      export HYPRCURSOR_SIZE=24

      # Wayland fixes.
      export _JAVA_AWT_WM_NONREPARENTING=1
      export QT_WAYLAND_DISABLE_WINDOWDECORATION=1

    '';

    programs = {
      hyprlock = {
        enable = true;
        settings = {
          general = {
            grace = 5; hide_cursor = true;
          };
          background = {
            path = "${config.xdg.stateHome}/wall.jpg";
            blur_passes = 2; brightness = 0.5;
          };
          input-field = {
            fade_timeout = 1000; monitor = "";
            placeholder_text = ""; size = "400, 60";
          };
        };
      };

      wofi = {
        enable = true;
        settings = {
          mode = "drun"; drun-print_desktop_file = true;
          width = "36%"; height = "40%"; allow_images = true;
          location = "center"; key_expand = "Ctrl-x";
        };
      };

      zsh.profileExtra = ''
        if uwsm check may-start; then
          exec uwsm start default
        fi
      '';
    };

    services = {
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

      # TODO: remove with Stylix 25.05 release.
      hyprpaper.enable = lib.mkForce false;
    };
  };
}
