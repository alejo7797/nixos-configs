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

    # TODO: remove with 25.05 release
    home.file = lib.mkIf (config.home.pointerCursor != null) {
      ".icons/default/index.theme".enable = false;
      ".icons/${config.home.pointerCursor.name}".enable = false;
    };

    home.packages = with pkgs; [
      # The default while under KDE.
      kdePackages.ocean-sound-theme
    ];

    xresources.path = "${config.xdg.configHome}/X11/xresources";
  };
}
