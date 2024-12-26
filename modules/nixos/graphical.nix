{ pkgs, lib, config, ... }: {

  options.myNixOS.graphical-environment = lib.mkEnableOption "basic graphical utilities";

  config = lib.mkIf config.myNixOS.graphical-environment {

    # Enable the plymouth splash screen.
    boot.plymouth = {
      enable = true;
    };

    # Install firefox and set it as default.
    programs.firefox.enable = true;
    environment.variables.BROWSER = "firefox";

    # Enable the following utilities.
    services.blueman.enable = true;
    programs.dconf.enable = true;
    services.geoclue2.enable = true;
    programs.nm-applet.enable = true;

    # Enable XDG desktop integration.
    xdg.portal = {
      enable = true;
      xdgOpenUsePortal = true;
    };

    # Manage storage devices.
    services.udisks2.enable = true;
    programs.gnome-disks.enable = true;

    # Enable and configure the GnuPG agent.
    programs.gnupg.agent = {
      enable = true;
      pinentryPackage = pkgs.pinentry-gnome3;
    };

    # Install the following packages system-wide.
    environment.systemPackages = with pkgs; [

      # System utilities.
      dconf-editor font-manager
      icoutils libnotify  mesa-demos
      pavucontrol pdftk playerctl
      polkit_gnome yubico-pam
      xorg.xeyes vulkan-tools

      # Essential applications.
      keepassxc kitty mpv
      libreoffice variety

    ];

    # Install the following fonts system-wide.
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
