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

    stylix = {
      enable = true;
    };

    fonts = {
      fontconfig.enable = true;
    };

    boot = {
      plymouth.enable = true;
    };

    hardware = {
      gpgSmartcards.enable = true;
      sane.enable = true;
    };

    i18n = {
      inputMethod.enable = true;
    };

    security = {
      rtkit.enable = true;
    };

    xdg.portal = {
      xdgOpenUsePortal = true;
    };

    virtualisation = {
      docker.rootless.enable = true;
    };

    environment.systemPackages = with pkgs; [
      altus
      anki
      audacity
      caprine-bin
      dconf-editor
      digikam
      ffmpeg
      filezilla
      font-manager
      gimp3
      gnucash
      gocryptfs
      icoutils
      imagemagick
      inkscape
      jellyfin-media-player
      joplin-desktop
      keepassxc
      kitty
      libfido2
      libreoffice
      libsForQt5.breeze-qt5
      libnotify
      mesa-demos
      mpv
      networkmanagerapplet
      pavucontrol
      pdftk
      piper
      playerctl
      seahorse
      simple-scan
      signal-desktop
      sops
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
      adb.enable = true;
      appimage.enable = true;
      autofirma.enable = true;
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
      geoclue2.enable = true;
      libinput.enable = true;
      pcscd.enable = true;
      printing.enable = true;
      ratbagd.enable = true;
      udisks2.enable = true;
    };

    fonts.packages = with pkgs; [
      corefonts
      font-awesome
      ipaexfont
      jigmo
      kanji-stroke-order-font
      noto-fonts
      noto-fonts-cjk-sans
      noto-fonts-cjk-serif
      source-han-sans
      source-han-serif
      source-sans
      takao
      vistafonts
    ];

  };
}
