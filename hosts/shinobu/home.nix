{ pkgs, ... }:

{
  home = {
    stateVersion = "24.11";
  };

  my = {
    autostart = with pkgs; [
      altus
      firefox
      joplin-desktop
      signal-desktop
      spotify
      steam
      thunderbird
      vesktop
      zotero
    ];
  };

  programs = {
    waybar.my = {
      location = "San Lorenzo de El Escorial";
      thermal-zone = 1;
    };
  };

  services = {
    # borgmatic.enable = true;
    syncthing.enable = true;
  };

  wayland.windowManager.hyprland.settings = {

    device = {
      name = "logitech-g203-lightsync-gaming-mouse";
      sensitivity = -1; # New fancy Logitech mouse.
    };

    # No need for Kanshi on a desktop computer.
    monitor =  "HDMI-1, 1920x1080@100, 0x0, 1";

  };
}
