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

    # Additionally set the following.
    home.sessionVariables = {
      QT_FONT_DPI = 120;
      QT_QPA_PLATFORMTHEME = "qt6ct";
    };

    # Set our desired font DPI.
    dconf.settings = {
      "org/gnome/desktop/interface" = {
        text-scaling-factor = 1.25;
      };
    };

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

  };

}
