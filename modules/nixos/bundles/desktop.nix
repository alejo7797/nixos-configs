{ config, lib, pkgs, ... }:

let
  cfg = config.my.desktop;
in

{
  options.my.desktop.enable = lib.mkEnableOption "desktop bundle";

  config = lib.mkIf cfg.enable {

    home-manager.sharedModules = [
      { my.desktop.enable = true; }
    ];

    environment.systemPackages = with pkgs; [
      btop
      dconf-editor
      ffmpeg
      font-manager
      icoutils
      imagemagick
      libreoffice
      libsForQt5.breeze-qt5
      libnotify
      mesa-demos
      pavucontrol
      pdftk
      piper
      seahorse
      simple-scan
      sqlitebrowser
      xorg.xeyes
      vulkan-tools
      yt-dlp
      yubioath-flutter
      zenity
    ];

    hardware = {
      gpgSmartcards.enable = true;
      sane.enable = true;
    };

    i18n.inputMethod.enable = true;

    programs = {
      firefox.enable = true;
      kdeconnect.enable = true;
      nm-applet.enable = true;
    };

    security.rtkit.enable = true;

    boot.plymouth.enable = true;

    stylix.enable = true;

    services = {
      dbus.packages = [ pkgs.gcr ];

      avahi.enable = true;
      blueman.enable = true;
      libinput.enable = true;
      pcscd.enable = true;
      printing.enable = true;
      ratbagd.enable = true;
      udisks2.enable = true;
    };

    fonts.packages = with pkgs; [
      corefonts
      font-awesome
      noto-fonts
      source-sans
      vistafonts

      # CJK fonts.
      ipaexfont
      jigmo
      kanji-stroke-order-font
      noto-fonts-cjk-sans
      noto-fonts-cjk-serif
      source-han-sans
      source-han-serif
      takao
    ];

  };
}
