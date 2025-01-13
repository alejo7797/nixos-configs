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
  imports = [ ./nvidia ./tuigreet.nix ];

  options.myNixOS = {
    graphical.enable = lib.mkEnableOption "common graphical utilities";
    laptop.enable = lib.mkEnableOption "laptop-specific configuration";
  };

  config = lib.mkIf cfg.enable {

    boot.plymouth.enable = true;

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

    hardware = {
      graphics = {
        enable = true;
        enable32Bit = true;
      };

      gpgSmartcards.enable = true;
      sane.enable = true;
    };

    security.rtkit.enable = true;

    services = {
      printing.enable = true;
      avahi.enable = true;
      saned.enable = true;

      pipewire = {
        enable = true;
        alsa.enable = true;
        alsa.support32Bit = true;
        pulse.enable = true;
      };

      blueman.enable = true;
      libinput.enable = true;
      flatpak.enable = true;
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
      noto-fonts-color-emoji
      source-sans
      vistafonts

      kanji-stroke-order-font
      kochi-substitute
      noto-fonts-cjk-sans
      source-han-sans
      source-han-serif

    ];
  };
}
