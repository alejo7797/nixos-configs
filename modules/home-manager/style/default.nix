{
  pkgs,
  config,
  lib,
  ...
}:

let
  cfg = config.myHome.style;
in

{
  imports = [ ../../stylix.nix ];

  options.myHome.style.enable = lib.mkEnableOption "user-level theming";

  config = lib.mkIf cfg.enable {

    stylix.enable = true;

    xdg = {
      configFile = {
        # Fix the look of QT applications.
        "qt5ct/qt5ct.conf".source = ./qt5ct.conf;
        "qt6ct/qt6ct.conf".source = ./qt6ct.conf;
        "kdeglobals".source = ./kdeglobals;

        "fontconfig" = {
          # Japanese fonts.
          source = ./fontconfig;
          recursive = true;
        };
      };

      # Configure Konsole - for use inside Dolphin.
      configFile."konsolerc".source = ./konsole/konsolerc;
      dataFile."konsole".source = ./konsole/data;
    };

    dconf.settings = {
      "org/gnome/desktop/interface" = {
        # Scale the user interface.
        text-scaling-factor = 1.25;
      };
    };

    stylix.iconTheme = {
      # Tell Stylix to use Papirus as our icon theme.
      enable = true; package = pkgs.papirus-icon-theme;
      dark = "Papirus-Dark"; light = "Papirus-Light";
    };
  };
}
