{
  lib,
  config,
  ...
}:

let
  cfg = config.my.qt;

  toINI = lib.generators.toINI {};

  colorschemeSlug = with config.lib.stylix; lib.concatStrings (
    lib.filter lib.isString (builtins.split "[^a-zA-Z]" colors.scheme)
  );

  iconTheme =
    if (config.stylix.polarity == "dark") then
      config.stylix.iconTheme.dark
    else
      config.stylix.iconTheme.light;

  qtctConf = toINI {
    Appearance = {
      color_scheme_path = "${config.xdg.dataHome}/color-schemes/${colorschemeSlug}.colors";
      custom_palette = true;
      icon_theme = iconTheme;
      style = "Breeze";
    };

    Fonts = with config.stylix.fonts; {
      fixed = "\"${monospace.name},${toString sizes.terminal},-1,5,50,0,0,0,0,0\"";
      general = "\"${sansSerif.name},${toString sizes.applications},-1,5,50,0,0,0,0,0\"";
    };
  };
in

{
  options.my.qt.enable = lib.mkEnableOption "QT application styling";

  config = lib.mkIf cfg.enable {

    qt = {
      enable = true;
      platformTheme.name = "qtct";
    };

    xdg.configFile = {

      "kdeglobals".text = toINI {
        KDE.widgetStyle = "qt6ct-style";
        General.TerminalApplication = "kitty";
        Icons.Theme = iconTheme;
      };

      "qt5ct/qt5ct.conf".text = qtctConf;
      "qt6ct/qt6ct.conf".text = qtctConf;

    };

    home.sessionVariables = {
      QT_FONT_DPI = "120";
    };

  };
}
