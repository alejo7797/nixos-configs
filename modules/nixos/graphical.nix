{
  lib,
  config,
  pkgs,
  ...
}:

let
  cfg = config.myNixOS.graphical;
in

{
  options.myNixOS.graphical.enable = lib.mkEnableOption "common graphical utilities";

  config = lib.mkIf cfg.enable {

    boot.plymouth.enable = true;

    console.font = "Lat2-Terminus16";

    myNixOS = {
      style.enable = true;
      firefox.enable = true;
      fcitx5.enable = true;
    };

    programs = {
      gnupg.agent.enable = true;
      ssh.startAgent = true;

      dconf.enable = true;
      gnome-disks.enable = true;
      kdeconnect.enable = true;
      nm-applet.enable = true;
    };

    hardware.gpgSmartcards.enable = true;
    hardware.sane.enable = true;

    security.rtkit.enable = true;

    services = {
      printing.enable = true;
      avahi.enable = true;
      system-config-printer.enable = true;
      saned.enable = true;

      pipewire = {
        enable = true;
        alsa.enable = true;
        alsa.support32Bit = true;
        pulse.enable = true;
      };

      blueman.enable = true;
      geoclue2.enable = true;
      gnome.gnome-keyring.enable = true;
      pcscd.enable = true;
      ratbagd.enable = true;
      udisks2.enable = true;
    };

    xdg.portal = {
      enable = true;
      xdgOpenUsePortal = true;
    };

    environment.systemPackages = with pkgs; [

      dconf-editor
      font-manager
      icoutils
      libnotify
      mesa-demos
      pavucontrol
      pdftk piper
      playerctl
      seahorse
      simple-scan
      sqlitebrowser
      xorg.xeyes
      vulkan-tools
      zenity

      keepassxc
      kitty mpv
      libreoffice
      yubioath-flutter
      variety

    ];

    fonts.packages = with pkgs; [

      corefonts
      dejavu_fonts
      font-awesome
      noto-fonts
      noto-fonts-cjk-sans
      noto-fonts-color-emoji
      source-han-sans
      source-han-serif
      source-sans
      vistafonts

    ];
  };
}
