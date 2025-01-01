{ pkgs, lib, config, ... }: {

  imports = [ ./syncthing.nix ];

  # Set the system hostname.
  myHome.hostname = "shinobu";

  # Basic settings needed by Home Manager.
  home.username = "ewan";
  home.homeDirectory = "/home/ewan";
  home.stateVersion = "24.11";

  # Load up our custom theme.
  myHome.style.enable = true;

  # Set up Hyprland, the tiling Wayland compositor.
  myHome.hyprland.enable = true;

  # Set up sway, the i3-compatible Wayland compositor.
  myHome.sway.enable = true;

  # Configure outputs.
  services.kanshi.settings = [
    {
      profile.name = "default";
      profile.outputs = [
        {
          criteria = "Microstep MSI MP273A PB4HC14702300";
          mode = "1920x1080@99.999Hz";
        }
      ];
    }
  ];

  # Host-specific Hyprland configuration.
  wayland.windowManager.hyprland.settings = {
    device = [
      {
        name = "logitech-g203-lightsync-gaming-mouse";
        sensitivity = -1;
      }
    ];
  };

  # Host-specific sway configuration.
  wayland.windowManager.sway.config = {
    input = {
      "1133:49298:Logitech_G203_LIGHTSYNC_Gaming_Mouse" = {
        pointer_accel = "-1";
      };
    };
  };

  # Install and configure joplin-desktop.
  myHome.joplin-desktop.enable = true;

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
