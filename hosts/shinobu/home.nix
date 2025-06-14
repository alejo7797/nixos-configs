{ lib, pkgs, ... }: {

  home = {
    stateVersion = "24.11";
  };

  xdg.autostart.my.entries = with pkgs; [

    # Well behaved guys.
    firefox
    thunderbird
    zotero
    signal-desktop
    vesktop

    {
      package = altus; # lol ok
      filename = "Altus.desktop";
    }

    {
      package = joplin-desktop;
      filename = "joplin.desktop";
    }

    {
      package = spotify; # well ok
      filename = "spotify.desktop";
    }

    {
      package = steam; # really?
      filename = "steam.desktop";
    }
  ];

  programs = {
    waybar.my = {
      location = "San Lorenzo de El Escorial";
      thermal-zone = 1;
    };
  };

  services = {
    # borgmatic.enable = true;
    syncthing.enable = true;

    kanshi.enable = lib.mkForce false;
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
