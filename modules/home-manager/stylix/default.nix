{ config, lib, pkgs, ... }:

let
  cfg = config.stylix or { enable = false; };
in

{
  config = lib.mkIf cfg.enable {

    # TODO: refactor
    my.qt.enable = true;

    stylix = {
      iconTheme = {
        # Setting not available within the NixOS module.
        enable = true; package = pkgs.papirus-icon-theme;
        dark = "Papirus-Dark"; light = "Papirus-Light";
      };

      targets = {
        # Don't create ~/.themes directory.
        gtk.flatpakSupport.enable = false;

        # Won't need these on 25.05.
        hyprpaper.enable = lib.mkForce false;
        hyprlock.enable = false;
      };
    };

    fonts.fontconfig.defaultFonts = with cfg.fonts; {
      monospace = [ monospace.name ];
      serif = [ serif.name ];
      sansSerif = [ sansSerif.name ];
      emoji = [ emoji.name ];
    };

    dconf.settings = {
      "org/gnome/desktop/interface" = {
        # Scale the user interface.
        text-scaling-factor = 1.25;
      };
    };

    home = {
      sessionVariables = {
        # Also fot Qt apps.
        QT_FONT_DPI = 120;
      };

      packages = [
        # The default sound theme for KDE.
        pkgs.kdePackages.ocean-sound-theme
      ];
    };

    # TODO: remove with 25.05 release
    home.file = lib.mkIf (config.home.pointerCursor != null) {
      ".icons/default/index.theme".enable = false;
      ".icons/${config.home.pointerCursor.name}".enable = false;
    };

    xresources.path = "${config.xdg.configHome}/X11/xresources";

    xdg.configFile = {
      # We prefer to keep the autostart directory read-only.
      "autostart/stylix-activate-gnome.desktop".enable = false;
      "autostart/stylix-activate-kde.desktop".enable = false;
    };
  };
}
