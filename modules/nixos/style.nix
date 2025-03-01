{
  lib,
  config,
  pkgs,
  ...
}:

let
  cfg = config.myNixOS.style;
in

{
  imports = [ ../stylix.nix ];

  options.myNixOS.style.enable = lib.mkEnableOption "system-level theming";

  config = lib.mkIf cfg.enable {

    stylix.enable = true;

    qt = {
      # Desktop independent QT customisation.
      enable = true; platformTheme = "qt5ct";
    };

    environment.variables = {
      # Set these early on.
      GTK_THEME = "adw-gtk3";
      QT_FONT_DPI = "120";

      # Try to improve Java applications' font rendering.
      _JAVA_OPTIONS = "-Dawt.useSystemAAFontSettings=lcd";
    };

    environment.systemPackages = with pkgs; [

      # Default KDE theme.
      libsForQt5.breeze-qt5
      kdePackages.breeze

      # The default KDE sound theme.
      kdePackages.ocean-sound-theme

      # Dolphin support.
      libsForQt5.qt5ct
      kdePackages.qt6ct

    ];
  };
}
