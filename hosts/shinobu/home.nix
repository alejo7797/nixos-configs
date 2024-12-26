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
      "5426:67:Razer_Razer_DeathAdder_Chroma" = {
        pointer_accel = "-0.8";
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

}
