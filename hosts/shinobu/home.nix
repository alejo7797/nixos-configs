{
  home = {
    stateVersion = "24.11";
  };

  xdg.autostart.my.entries = {
    altus = "Altus.desktop";
    firefox = "firefox.desktop";
    joplin-desktop = "joplin.desktop";
    signal-desktop = "signal.desktop";
    spotify = "spotify.desktop";
    steam = "steam.desktop";
    thunderbird = "thunderbird.desktop";
    vesktop = "vesktop.desktop";
    zotero = "zotero.desktop";
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
    monitor = "HDMI-1, 1920x1080@100, 0x0, 1";

  };
}
