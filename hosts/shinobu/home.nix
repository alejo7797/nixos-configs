{
  pkgs,
  ...
}:

{
  home = {
    username = "ewan";
    homeDirectory = "/home/ewan";
    stateVersion = "24.11";
  };

  sops.secrets = {
    "calendars/sonarr" = { };
    "calendars/harvard" = { };
  };

  my = {
    joplin.enable = true;

    autostart = with pkgs; [
      firefox joplin-desktop
      spotify steam thunderbird
      vesktop zotero
    ];
  };

  myHome = {
    hyprland.enable = true;
    sway.enable = true;

    firefox.enable = true;
    thunderbird.enable = true;

    waybar.thermal-zone = 1;
    waybar.location = "San Lorenzo de El Escorial";
  };

  services = {
    kanshi.settings = [
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

    syncthing.enable = true;
  };

  wayland.windowManager.hyprland.settings = {
    device = [
      {
        name = "logitech-g203-lightsync-gaming-mouse";
        sensitivity = -1;
      }
    ];
  };

  wayland.windowManager.sway.config = {
    input = {
      "1133:49298:Logitech_G203_LIGHTSYNC_Gaming_Mouse" = {
        pointer_accel = "-1";
      };
    };
  };
}
