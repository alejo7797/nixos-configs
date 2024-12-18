{ lib, config, ... }: {

  imports = [ ../style.nix ];

  options.myNixOS.style.enable = lib.mkEnableOption "enable system theme";

  config = lib.mkIf config.myNixOS.style.enable {

    # Enable common theme components.
    myStyle.enable = true;

    # Work through QT application theming.
    environment.variables = {
      QT_FONT_DPI = 120;
      QT_QPA_PLATFORMTHEME = "qt6ct";
    };

  };

}
