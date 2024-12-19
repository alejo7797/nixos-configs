{ pkgs, lib, myLib, config, ... }: {

  imports = [ ../style.nix ];

  options.myHome.style.enable = lib.mkEnableOption "the user theme";

  config = lib.mkIf config.myHome.style.enable {

    # Enable common theme components.
    myStyle.enable = true;

    # Fix the look of QT applications.
    xdg.configFile = {
      "kdeglobals".source = ../dotfiles/kdeglobals;
      "qt5ct/qt5ct.conf".source = ../dotfiles/qt5ct.conf;
      "qt6ct/qt6ct.conf".source = ../dotfiles/qt6ct.conf;
    };

    # Set our desired font DPI.
    dconf.settings."org/gnome/desktop/interface" = {
      text-scaling-factor = 1.25;
    };

    # And also for QT apps.
    home.sessionVariables.QT_FONT_DPI = 120;

    # Use Papirus as our icon theme.
    stylix.iconTheme = {
      enable = true;
      package = pkgs.papirus-icon-theme;
      dark = "Papirus-Dark";
      light = "Papirus-Light";
    };

    # Use the default KDE sound theme.
    gtk = myLib.gtkExtra "gtk-sound-theme-name" "ocean";
    dconf.settings."org/gnome/desktop/sound".theme-name = "ocean";

    # Pass our settings to xsettingsd.
    services.xsettingsd = {
      enable = true;
      settings = {
        "Net/ThemeName" = "adw-gkt3";
        "Net/IconThemeName" = "Papirus-Dark";
        "Net/SoundThemeName" = "ocean";
        "Gtk/CursorThemeName" = "breeze_cursors";
        "Xft/DPI" = 122880;
      };
    };

  };

}
