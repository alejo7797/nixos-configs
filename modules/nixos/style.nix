{
  lib,
  inputs,
  config,
  pkgs,
  ...
}:

let
  cfg = config.myNixOS.style;
in

{
  imports = [ ../style.nix ];

  options.myNixOS.style.enable = lib.mkEnableOption "system theme components";

  config = lib.mkIf cfg.enable {

    nixpkgs.overlays = [
      (_: prev: {
        # Access ilya-fedin's Nix repository.
        ilya-fedin = import inputs.ilya-fedin { pkgs = prev; };
      })
    ];

    qt = {
      enable = true;
      platformTheme = "qt5ct";
    };

    environment.variables = {
      # Set theme variables early.
      GTK_THEME = "adw-gtk3";
      QT_FONT_DPI = "120";

      # Improve Java font rendering.
      _JAVA_OPTIONS = "-Dawt.useSystemAAFontSettings=lcd";
    };

    # Enable common theme components.
    myStylix.enable = true;

    # Install necessary theme packages.
    environment.systemPackages = with pkgs; [

      # The default KDE theme.
      libsForQt5.breeze-qt5
      kdePackages.breeze

      # The default KDE sound theme.
      kdePackages.ocean-sound-theme

      # Improved fork for KDE apps.
      ilya-fedin.qt5ct
      ilya-fedin.qt6ct

    ];
  };
}
