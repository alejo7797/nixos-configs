{ pkgs, lib, config, ... }: {

  imports = [ ../style.nix ];

  options.myNixOS.style.enable = lib.mkEnableOption "the system theme";

  config = lib.mkIf config.myNixOS.style.enable {

    # Style QT applications consistently.
    qt = {
      enable = true;
      platformTheme = "qt5ct";
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

      # Great fork for compatibility
      # with KDE apps like dolphin.
      ilya-fedin.qt5ct
      ilya-fedin.qt6ct

    ];

  };

}
