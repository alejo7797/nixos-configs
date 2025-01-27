{
  pkgs,
  ...
}:

{
  stylix = {

    # Specifying an image is mandatory.
    image = builtins.fetchurl {
      url = "https://w.wallhaven.cc/full/zy/wallhaven-zye9ry.jpg";
      sha256 = "16d5pch4544knygndsslmh682fxp6sqwn5b9vnrb35ji7m5zfcm0";
    };

    # Set the colorscheme.
    base16Scheme = "${pkgs.base16-schemes}/share/themes/tomorrow-night.yaml";

    # Specify that we are using a dark colorscheme.
    polarity = "dark";

    # Configure our desired fonts.
    fonts = {
      sizes = {
        applications = 10;
        terminal = 11;
      };

      serif = {
        package = pkgs.noto-fonts;
        name = "Noto Serif";
      };

      sansSerif = {
        package = pkgs.noto-fonts;
        name = "Noto Sans";
      };

      monospace = {
        package = pkgs.nerdfonts.override { fonts = [ "Hack" ]; };
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
