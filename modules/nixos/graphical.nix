{ pkgs, lib, config, ... }: let

  cfg = config.myNixOS.graphical;

in {

  options.myNixOS.graphical.enable = lib.mkEnableOption "common graphical environment settings";

  config = lib.mkIf cfg.enable {

    # Customise the tty.
    console.font = "Lat2-Terminus16";

    # Enable the plymouth splash screen.
    boot.plymouth.enable = true;

    # Enable my custom system theme.
    myNixOS.style.enable = true;

    # Install and configure firefox.
    myNixOS.firefox.enable = true;

    # Enable the SSH agent.
    programs.ssh.startAgent = true;

    # Enable the GnuPG agent.
    programs.gnupg.agent.enable = true;
    hardware.gpgSmartcards.enable = true;

    # Install and configure Fcitx5.
    myNixOS.fcitx5.enable = true;

    # Enable CUPS.
    services.printing.enable = true;
    services.avahi.enable = true;
    services.system-config-printer.enable = true;

    # Enable SANE.
    hardware.sane.enable = true;
    services.saned.enable = true;

    # Enable sound support.
    security.rtkit.enable = true;
    services.pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
    };

    # Enable the following utilities.
    services.blueman.enable = true;
    programs.dconf.enable = true;
    services.geoclue2.enable = true;
    programs.gnome-disks.enable = true;
    services.gnome.gnome-keyring.enable = true;
    programs.kdeconnect.enable = true;
    programs.nm-applet.enable = true;
    services.pcscd.enable = true;
    services.ratbagd.enable = true;
    services.udisks2.enable = true;

    # Enable XDG desktop integration.
    xdg.portal = {
      enable = true;
      xdgOpenUsePortal = true;
    };

    # Install the following packages.
    environment.systemPackages = with pkgs; [

      # System utilities.
      dconf-editor font-manager icoutils
      libnotify mesa-demos pavucontrol
      pdftk piper playerctl polkit_gnome
      seahorse sqlitebrowser yubico-pam
      xorg.xeyes vulkan-tools zenity

      # Essential applications.
      keepassxc kitty mpv
      libreoffice variety

    ];

    # Install the following fonts.
    fonts.packages = with pkgs; [
      corefonts
      dejavu_fonts
      font-awesome
      noto-fonts
      noto-fonts-cjk-sans
      noto-fonts-color-emoji
      noto-fonts-monochrome-emoji
      source-han-sans
      source-han-serif
      source-sans
      vistafonts
    ];
  };
}
