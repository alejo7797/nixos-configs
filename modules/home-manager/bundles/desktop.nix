{ config, lib, pkgs, ... }:

let
  cfg = config.my.desktop;
in

{
  options.my.desktop.enable = lib.mkEnableOption "desktop bundle";

  config = lib.mkIf cfg.enable {

    xdg = {
      autostart.enable = true;
      mimeApps.enable = true;
    };

    programs = {
      btop.enable = true;
      direnv.enable = true;
      firefox.enable = true;
      gpg.enable = true;
      joplin-desktop.enable = true;
      kitty.enable = true;
      lsd.enable = true;
      mpv.enable = true;
      nixvim.enable = true;
      thunderbird.enable = true;
      zathura.enable = true;
    };

    programs.my = {
      dolphin.enable = true;
      fcitx5.enable = true;
      keepassxc.enable = true;
    };

    services = {
      activitywatch.enable = true;
      gnome-keyring.enable = true;
      gpg-agent.enable = true;
      kdeconnect.indicator = true;
      mpris-proxy.enable = true;
      playerctld.enable = true;
    };

    services.my = {
      jellyfin-rpc.enable = true;
      variety.enable = true;
      yubikey.enable = true;
    };

    home.packages = with pkgs; [
      favicon-generator
      round-corners
    ];

    home.sessionVariables = {

      CARGO_HOME = "${config.xdg.dataHome}/cargo";
      CUDA_CACHE_PATH = "${config.xdg.cacheHome}/nv";
      WINEPREFIX = "${config.xdg.dataHome}/wine";

      # Some Java applications actually respect this which avoids creating the ~/.java directory.
      _JAVA_OPTIONS = "$_JAVA_OPTIONS -Djava.util.prefs.userRoot=${config.xdg.configHome}/java";
    };

    gtk.gtk2.configLocation = "${config.xdg.configHome}/gtk-2.0/gtkrc";

  };
}
