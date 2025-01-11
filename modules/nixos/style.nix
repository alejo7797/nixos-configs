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
      # Access ilya-fedin's repository.
      (_: prev: {
        ilya-fedin = import inputs.ilya-fedin {
          pkgs = prev;
        };
      })
    ];

    # Style QT applications consistently.
    qt = {
      enable = true;
      platformTheme = "qt5ct";
    };

    # Set theme variables early on.
    environment.variables = {
      GTK_THEME = "adw-gtk3";
      QT_FONT_DPI = "120";
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

      # From ilya-fedin's repository.
      pkgs.ilya-fedin.qt5ct
      pkgs.ilya-fedin.qt6ct

    ];
  };
}
