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
  imports = [
    ./hyprland
    ./sway
    ./swaync
    ./waybar
    ./wlogout
  ];

  options.myHome.wayland.enable = lib.mkEnableOption "Wayland";

  config = lib.mkIf cfg.enable {
    myHome = {
      # Configure common graphical utilities.
      graphical.enable = true;

      # Install and configure waybar.
      waybar.enable = true;

      # Install and configure swaync.
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

    # Install and configure hyprlock.
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

    # Install and configure wofi.
    programs.wofi = {
      enable = true;
      settings = {
        mode = "drun"; drun-print_command = true;
        width = "36%"; height = "40%"; allow_images = true;
        location = "center"; key_expand = "Ctrl-x";
      };
    };

    # Stylix wants to set the wallpaper too.
    stylix.targets.hyprlock.enable = false;

    services = {
      # Enable the kanshi daemon.
      kanshi.enable = true;

      # Enable and configure gammastep.
      gammastep = {
        enable = true;
        tray = true;
        provider = lib.mkDefault "geoclue2";
        settings.general = {
          fade = 1; gamma = 0.8;
          adjustment-method = "wayland";
        };
      };

      # Enable and configure swayidle.
      swayidle =
        let
          hyprlock = "${pkgs.hyprlock}/bin/hyprlock";
          loginctl = "${pkgs.systemd}/bin/loginctl";
          systemctl = "${pkgs.systemd}/bin/systemctl";
        in
        {
          enable = true;
          events = [
            { event = "lock"; command = "${pkgs.playerctl}/bin/playerctl -a pause"; }
            { event = "lock"; command = "${pkgs.procps}/bin/pidof ${hyprlock} || ${hyprlock}"; }
            { event = "before-sleep"; command = "${loginctl} lock-session"; }
          ];
          timeouts = [
            { timeout = 600; command = "${loginctl} lock-session"; }
            { timeout = 660; command = "${systemctl} suspend"; }
          ];
        };
    };
  };
}
