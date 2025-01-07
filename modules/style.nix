{ pkgs, lib, config, ... }:

let
  cfg = config.myStylix;
in

{
  options.myStylix.enable = lib.mkEnableOption "common theme components";

  config.stylix = lib.mkIf cfg.enable {
    enable = true;

    # Specifying an image is mandatory.
    image = builtins.fetchurl {
      url = "https://w.wallhaven.cc/full/zy/wallhaven-zye9ry.jpg";
      sha256 = "16d5pch4544knygndsslmh682fxp6sqwn5b9vnrb35ji7m5zfcm0";
    };

    # Set the color scheme.
    polarity = "dark";
    base16Scheme = ./tomorrow-night.yaml;

    # Configure our desired fonts.
    fonts = {
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
        package = pkgs.nerdfonts.override {fonts = ["Hack"];};
        name = "Hack Nerd Font";
      };

      emoji = {
        package = pkgs.noto-fonts-emoji;
        name = "Noto Color Emoji";
      };
    };

    # Use the default KDE cursor theme.
    cursor = {
      package = pkgs.kdePackages.breeze;
      name = "breeze_cursors";
      size = 24;
    };
  };
}
