{ pkgs, lib, config, ... }: {

  imports = [
    ./hyprland ./sway ./waybar
    ./swaync ./wlogout
  ];

  options.myHome.wayland.enable = lib.mkEnableOption "Wayland";

  config = lib.mkIf config.myHome.wayland.enable {

    # Configure common graphical applications.
    myHome.graphical.enable = true;

    # Set environment variables using UWSM.
    xdg.configFile."uwsm/env".text = ''

      # Access local scripts.
      export PATH="$PATH''${PATH:+:}$HOME/.local/bin"

      # Set the cursor size.
      export XCURSOR_SIZE=24
      export HYPRCURSOR_SIZE=24

      # Wayland fixes.
      export _JAVA_AWT_WM_NONREPARENTING=1
      export QT_WAYLAND_DISABLE_WINDOWDECORATION=1

    '';

    # Install and enable kanshi.
    services.kanshi = {
      enable = true;
      systemdTarget = "graphical-session.target";
    };

    # Install and configure wofi.
    programs.wofi = {
      enable = true;
      settings = {
        show = "drun";
        width = "36%";
        allow_images = true;
        key_expand = "Ctrl-x";
        drun-print_desktop_file = true;
      };
    };

    # Install and configure hyprlock.
    programs.hyprlock = {
      enable = true;
      settings = {
        general = {
          grace = 5;
          hide_cursor = true;
        };
        background = {
          path = "${config.xdg.configHome}/hypr/wall.png";
          blur_passes = 2;
          brightness = 0.5;
        };
        input-field = {
          monitor = "";
          fade_timeout = 1000;
          placeholder_text = "";
          size = "400, 60";
        };
      };
    };

    # Stylix wants to set the wallpaper too.
    stylix.targets.hyprlock.enable = false;

    # Enable and configure gammastep.
    services.gammastep = {
      enable = true;
      tray = true;
      provider = lib.mkDefault "geoclue2";
      settings.general = {
        fade = 1; gamma = 0.8;
        adjustment-method = "wayland";
      };
    };

    # Enable and configure swayidle.
    services.swayidle =
      let
        lock = "${pkgs.hyprlock}/bin/hyprlock";
      in
      {
        enable = true;
        events = [
          { event = "lock"; command = "${pkgs.playerctl}/bin/playerctl -a pause"; }
          { event = "lock"; command = "${pkgs.procps}/bin/pidof ${lock} || ${lock}"; }
          { event = "before-sleep"; command = "loginctl lock-session"; }
        ];
        timeouts = [
          { timeout = 600; command = "loginctl lock-session"; }
          { timeout = 660; command = "systemctl suspend"; }
        ];
      };

  };
}
