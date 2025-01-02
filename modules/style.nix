{ pkgs, lib, config, ... }: {

options.myStyle.enable = lib.mkEnableOption "common theme components";

config = lib.mkIf config.myStyle.enable {

    # Enable and configure Stylix.
    stylix.enable = true;
    stylix.polarity = "dark";
    stylix.image = ./wallpaper.png;
    stylix.base16Scheme = "${pkgs.base16-schemes}/share/themes/tomorrow-night.yaml";

    # Configure our desired fonts.
    stylix.fonts = {
      sizes = {
        applications = 10;
        terminal = 11;
      };

      serif = config.stylix.fonts.sansSerif;

      sansSerif = {
        package = pkgs.noto-fonts;
        name = "Noto Sans";
      };

      monospace = {
        package = (pkgs.nerdfonts.override { fonts = [ "Hack" ]; });
        name = "Hack Nerd Font";
      };

      emoji = {
        package = pkgs.noto-fonts-emoji;
        name = "Noto Color Emoji";
      };
    };

    # Use the default KDE cursor theme.
    stylix.cursor = {
      package = pkgs.kdePackages.breeze;
      name = "breeze_cursors";
      size = 24;
    };
  };
}
