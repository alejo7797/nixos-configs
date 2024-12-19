{ pkgs, lib, config, ... }: {

  options.myHome.wayland.enable = lib.mkEnableOption "wayland";

  config = lib.mkIf config.myHome.wayland.enable {

    # Configure common graphical applications.
    myHome.graphical-environment = true;

    # Configure waybar.
    programs.waybar = {
      enable = true;
    };

    # Configure swaync.
    services.swaync = {
      enable = true;
    };

    # Configure wofi.
    programs.wofi = {
      enable = true;
      settings = {
        show = "drun";
        allow_images = true;
      };
    };

    # Configure kanshi.
    services.kanshi = {
      enable = true;
    };

    # Configure swayidle.
    services.swayidle = {
      enable = true;
      events = [
        { event = "lock"; command = "playerctl -a pause && pidof hyprlock || hyprlock"; }
        { event = "before-sleep"; command = "loginctl lock-session"; }
      ];
      timeouts = [
        { timeout = 600; command = "loginctl lock-session"; }
        { timeout = 660; command = "systemctl suspend-then-hibernate"; }
      ];
    };

  };

}
