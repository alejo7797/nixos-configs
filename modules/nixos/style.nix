{
  lib,
  config,
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
      # Desktop independent QT look and feel.
      enable = true; platformTheme = "qt5ct";
    };

    environment.variables = {
      # Set these variables early during startup.
      GTK_THEME = "adw-gtk3"; QT_FONT_DPI = "120";

      # Try to improve Java applications' font rendering.
      _JAVA_OPTIONS = "-Dawt.useSystemAAFontSettings=lcd";
    };
  };
}
