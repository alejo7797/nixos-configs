{ pkgs, lib, config, ... }: {

    options.myNixOS.graphical-environment = lib.mkEnableOption "some basic graphical utilities";

    config = lib.mkIf config.myNixOS.graphical-environment {

      # Install firefox and set it as default.
      programs.firefox.enable = true;
      environment.variables.BROWSER = "firefox";

      # Enable the following utilities.
      services.blueman.enable = true;
      programs.dconf.enable = true;
      services.geoclue2.enable = true;
      programs.kdeconnect.enable = true;
      programs.nm-applet.enable = true;

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
        bemenu dex dconf-editor
        font-manager libnotify
        pavucontrol pdftk
        playerctl xsettingsd

        # QT theming support.
        libsForQt5.breeze-qt5
        kdePackages.breeze
        ilya-fedin.qt5ct
        ilya-fedin.qt6ct

        # Essential applications.
        keepassxc kitty
        mpv libreoffice

      ];

      # Install the following fonts system-wide.
      fonts.packages = with pkgs; [

        corefonts
        dejavu_fonts
        font-awesome
        noto-fonts-cjk-sans
        noto-fonts-color-emoji
        source-han-sans
        source-han-serif
        source-sans

      ];

    };

}
