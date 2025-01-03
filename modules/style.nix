{ pkgs, lib, config, ... }: {

options.myStyle.enable = lib.mkEnableOption "common theme components";

config = lib.mkIf config.myStyle.enable {

    # Enable and configure Stylix.
    stylix.enable = true;

    # Specifying an image is mandatory.
    stylix.image = builtins.fetchurl {
      url = "https://w.wallhaven.cc/full/zy/wallhaven-zye9ry.jpg";
      sha256 = "16d5pch4544knygndsslmh682fxp6sqwn5b9vnrb35ji7m5zfcm0";
    };

    # Set the color scheme.
    stylix.polarity = "dark";
    stylix.base16Scheme = ./tomorrow-night.yaml;

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
