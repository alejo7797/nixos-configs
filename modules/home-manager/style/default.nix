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

  config = lib.mkIf cfg.enable ({

    stylix.enable = true;

    xdg = {
      configFile = {
        # Fix the look of KDE applications.
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
  }

  //

  {
    # The following QT options are set by Stylix,
    # but unfortunately not in the 24.11 release.

    qt = {
      enable = true;
      # Welcome back, kvantum!
      platformTheme.name = "qtct";
      style.name = "kvantum";
    };

    xdg.configFile =

      let

        kvantumPackage =
          let

            kvconfig = config.lib.stylix.colors {
              template = ./kvconfig.mustache;
              extension = ".kvconfig";
            };

            svg = config.lib.stylix.colors {
              template = ./kvantum-svg.mustache;
              extension = "svg";
            };

          in

            pkgs.runCommandLocal "base16-kvantum" { } ''
              directory="$out/share/Kvantum/Base16Kvantum"
              mkdir --parents "$directory"
              cp ${kvconfig} "$directory/Base16Kvantum.kvconfig"
              cp ${svg} "$directory/Base16Kvantum.svg"
            '';

        qtctConf = ''
          [Appearance]
          style="kvantum"
          icon_theme="Papirus-Dark"
        '';

      in

      {
        "Kvantum/kvantum.kvconfig".source =
          (pkgs.formats.ini { }).generate "kvantum.kvconfig"
            { General.theme = "Base16Kvantum"; };

        "Kvantum/Base16Kvantum".source =
          "${kvantumPackage}/share/Kvantum/Base16Kvantum";

        "qt5ct/qt5ct.conf".text = qtctConf;
        "qt6ct/qt6ct.conf".text = qtctConf;
      };
  });
}
