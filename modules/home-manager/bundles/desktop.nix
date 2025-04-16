{ config, lib, pkgs, ... }:

let
  cfg = config.my.desktop;
in

{
  options.my.desktop.enable = lib.mkEnableOption "desktop bundle";

  config = lib.mkIf cfg.enable {

    xdg.mimeApps.enable = true;

    programs = {
      direnv.enable = true;
      gpg.enable = true;
      joplin-desktop.enable = true;
      kitty.enable = true;
      lsd.enable = true;
      mpv.enable = true;
      nixvim.enable = true;
      zathura.enable = true;
    };

    programs.my = {
      dolphin.enable = true;
      fcitx5.enable = true;
      keepassxc.enable = true;
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
      # Keep application data outside of $HOME.
      CUDA_CACHE_PATH="${config.xdg.cacheHome}/nv";
      GPODDER_HOME = "${config.xdg.dataHome}/gPodder";
      WINEPREFIX = "${config.xdg.dataHome}/wine";

      # For whatever reason, Plex Desktop will create a "~/Application Support" directory otherwise.
      PLEX_MEDIA_SERVER_APPLICATION_SUPPORT_DIR = "${config.xdg.dataHome}/plex/Application Support";
    };

    gtk.gtk2.configLocation = "${config.xdg.configHome}/gtk-2.0/gtkrc";

  };
}
