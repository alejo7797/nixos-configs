{ pkgs, lib, config, ... }: {

  options.myHome.wayland.enable = lib.mkEnableOption "wayland";

  config = lib.mkIf config.myHome.wayland.enable {

    # Install and configure wofi.
    programs.wofi = {
      enable = true;
      settings = {
        show = "drun";
        allow_images = true;
      };
    };

    # Enable and configure kanshi.
    services.kanshi = {
      enable = true;
    };

    # Install and configure waybar.
    programs.waybar = {
      enable = true;
    };

    # Install and configure swaync.
    services.swaync = {
      enable = true;
    };

    # Enable and configure swayidle.
    services.swayidle = {
      enable = true;
      events = [
        { event = "lock"; command = "playerctl -a pause && pidof hyprlock || hyprlock"; }
        { event = "before-sleep"; command = "loginctl lock-session"; }
      ];
      timeouts = [
        {timeout = 600; command = "loginctl lock-session"; }
        {timeout = 660; command = "systemctl suspend-then-hibernate"; }
      ];
    };

  };

}
