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

    stylix.enable = true;

    boot.plymouth.enable = true;

    hardware = {
      gpgSmartcards.enable = true;
      sane.enable = true;
    };

    i18n.inputMethod.enable = true;

    security.rtkit.enable = true;

    environment.systemPackages = with pkgs; [
      anki
      audacity
      btop
      castero
      dconf-editor
      digikam
      ffmpeg
      filezilla
      font-manager
      gimp
      icoutils
      imagemagick
      inkscape
      joplin-desktop
      keepassxc
      kitty
      libreoffice
      libsForQt5.breeze-qt5
      libnotify
      mesa-demos
      mpv
      pavucontrol
      pdftk
      piper
      plex-desktop
      seahorse
      simple-scan
      spotify
      sqlitebrowser
      tellico
      xorg.xeyes
      vesktop
      vulkan-tools
      winetricks
      wineWowPackages.stable
      yt-dlp
      yubioath-flutter
      zathura
      zenity
    ];

    programs = {
      appimage.enable = true;
      my.dolphin.enable = true;
      firefox.enable = true;
      java.enable = true;
      kdeconnect.enable = true;
      steam.enable = true;
      thunderbird.enable = true;
      wireshark.enable = true;
    };

    services = {
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
