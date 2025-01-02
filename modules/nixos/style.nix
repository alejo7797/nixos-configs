{ pkgs, lib, config, ... }: {

  imports = [ ../style.nix ];

  options.myNixOS.style.enable = lib.mkEnableOption "system theme components";

  config = lib.mkIf config.myNixOS.style.enable {

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
    myStyle.enable = true;

    # Install necessary theme packages.
    environment.systemPackages = with pkgs; [

      # The default KDE theme.
      libsForQt5.breeze-qt5
      kdePackages.breeze

      # The default KDE sound theme.
      kdePackages.ocean-sound-theme

      # Great fork for compatibility with KDE apps.
      ilya-fedin.qt5ct
      ilya-fedin.qt6ct

    ];
  };
}
