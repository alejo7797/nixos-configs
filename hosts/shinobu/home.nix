{ pkgs, lib, config, ... }: {

myHome.hostname = "shinobu";
  home.username = "ewan";
  home.homeDirectory = "/home/ewan";
  home.stateVersion = "24.11";

  # Load up our custom theme.
  myHome.style.enable = true;

  # Set up sway, the i3-compatible Wayland compositor.
  myHome.sway.enable = true;

  wayland.windowManager.sway.config = {

    # Configure input devices.
    input = {
      "1133:49298:Logitech_G203_LIGHTSYNC_Gaming_Mouse" = {
        pointer_accel = "-1";
      };
    };

    # Configure outputs.
    output = {
      "Microstep MSI MP273A PB4HC14702300" = {
        mode = "1920x1080@99.999Hz";
        position = "0,0";
        scale = "1";
      };
    };

  };

  # Autostart applications.
  myHome.xdgAutostart = with pkgs; [

    spotify steam vesktop zotero

    # Need to specify .desktop file manually.
    (joplin-desktop // { desktopFile = "@joplinapp-desktop.desktop"; })

  ];

  # Set the location used by gammastep manually.
  # https://github.com/NixOS/nixpkgs/issues/321121
  services.gammastep = {
    provider = "manual";
    settings.manual = {
      lat = 40; lon = -4;
    };
  };

}
