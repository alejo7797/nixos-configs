{ config, lib, pkgs, ... }:

let
  cfg = config.my.desktop;
in

{
  options.my.desktop.enable = lib.mkEnableOption "desktop bundle";

  config = lib.mkIf cfg.enable {

    # TODO: migrate this completely
    myHome.graphical.enable = true;

    programs = {
      direnv.enable = true;
      my.fcitx5.enable = true;
      gpg.enable = true;
      my.keepassxc.enable = true;
      lsd.enable = true;
      nixvim.enable = true;
    };

    services = {
      gnome-keyring.enable = true;
      gpg-agent.enable = true;
      kdeconnect.indicator = true;
      mpris-proxy.enable = true;
      playerctld.enable = true;
      my.variety.enable = true;
    };

    home.packages = with pkgs; [
      favicon-generator
      round-corners
      sleep-deprived
    ];

    home.sessionVariables = {
      # Keep application data outside of user $HOME.
      GPODDER_HOME = "${config.xdg.dataHome}/gPodder";
      WINEPREFIX = "${config.xdg.dataHome}/wine";

      # For whatever reason, Plex Desktop will create a "~/Application Support" directory otherwise.
      PLEX_MEDIA_SERVER_APPLICATION_SUPPORT_DIR = "${config.xdg.dataHome}/plex/Application Support";
    };

    gtk.gtk2.configLocation = "${config.xdg.configHome}/gtk-2.0/gtkrc";

  };
}
