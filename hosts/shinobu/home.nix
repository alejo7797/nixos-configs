{
  pkgs,
  ...
}:

{
  home = {
    stateVersion = "24.11";
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
}
