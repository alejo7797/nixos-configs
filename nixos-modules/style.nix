{ lib, config, ... }: {

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

  };

}
