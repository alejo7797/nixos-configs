{
  lib,
  config,
  pkgs,
  ...
}:

let
  cfg = config.my.style;
in

{
  options.my.style.enable = lib.mkEnableOption "user-level theming";

  config = lib.mkIf cfg.enable {

    my.qt.enable = true;

    xdg = {
      configFile = {
        "fontconfig" = {
          # Japanese fonts.
          source = ./fontconfig;
          recursive = true;
        };
      };
    };

    dconf.settings = {
      "org/gnome/desktop/interface" = {
        # Scale the user interface.
        text-scaling-factor = 1.25;
      };
    };

    home.packages = with pkgs; [
      # The default while under KDE.
      kdePackages.ocean-sound-theme
    ];

    stylix.iconTheme = {
      # Tell Stylix to use Papirus as our icon theme.
      enable = true; package = pkgs.papirus-icon-theme;
      dark = "Papirus-Dark"; light = "Papirus-Light";
    };
  };
}
