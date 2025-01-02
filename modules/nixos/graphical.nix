{ pkgs, lib, config, ... }: {

  options.myNixOS.graphical.enable = lib.mkEnableOption "basic graphical utilities";

  config = lib.mkIf config.myNixOS.graphical.enable {

    # Enable the plymouth splash screen.
    boot.plymouth.enable = true;

    # Install and configure firefox.
    myNixOS.firefox.enable = true;

    # Enable the SSH agent.
    programs.ssh.startAgent = true;

    # Enable the GnuPG agent.
    programs.gnupg.agent.enable = true;
    hardware.gpgSmartcards.enable = true;

    # Enable the following utilities.
    services.blueman.enable = true;
    programs.dconf.enable = true;
    services.geoclue2.enable = true;
    programs.gnome-disks.enable = true;
    services.gnome.gnome-keyring.enable = true;
    programs.kdeconnect.enable = true;
    programs.nm-applet.enable = true;
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
      source-han-sans
      source-han-serif
      source-sans
    ];
  };
}
