{ pkgs, lib, config, ... }: {

  imports = [ ./hyprland.nix ./sway ./waybar.nix ./swaync.nix ];

  options.myHome.wayland.enable = lib.mkEnableOption "wayland";

  config = lib.mkIf config.myHome.wayland.enable {

    # Configure common graphical applications.
    myHome.graphical-environment = true;

    # Enable kanshi.
    services.kanshi.enable = true;

    # Install and configure wofi.
    programs.wofi = {
      enable = true;
      settings = {
        show = "drun";
        allow_images = true;
      };
    };

    # Install and configure hyprlock.
    programs.hyprlock = {
      enable = true;
    };

    # Enable and configure gammastep.
    services.gammastep = {
      enable = true;
      tray = true;
      provider = "geoclue2";
      settings.general = {
        fade = 1; gamma = 0.8;
        adjustment-method = "wayland";
      };
    };

    # Enable and configure swayidle.
    services.swayidle = let
      lock = "${pkgs.hyprlock}/bin/hyprlock";
    in {
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
