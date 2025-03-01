{ pkgs, ... }: {

  stylix = {

    image = builtins.fetchurl {
      # Must specify a wallpaper image even if we don't really need it.
      url = "https://w.wallhaven.cc/full/zy/wallhaven-zye9ry.jpg";
      sha256 = "16d5pch4544knygndsslmh682fxp6sqwn5b9vnrb35ji7m5zfcm0";
    };

    # Tomorrow Night is still the best for me even now. Thank you chriskempson.
    base16Scheme = "${pkgs.base16-schemes}/share/themes/tomorrow-night.yaml";

    polarity = "dark";

    fonts = rec {
      sizes = {
        applications = 10;
        terminal = 11;
      };

      sansSerif = {
        package = pkgs.noto-fonts;
        name = "Noto Sans";
      };

      # Why would I not?
      serif = sansSerif;

      monospace = {
        name = "Hack Nerd Font"; # Avoid grabbing all Nerd Fonts.
        package = pkgs.nerdfonts.override { fonts = [ "Hack" ]; };
      };

      emoji = {
        # Would prefer monochrome.
        package = pkgs.noto-fonts-emoji;
        name = "Noto Color Emoji";
      };
    };

    cursor = {
      # Use the default KDE cursor theme.
      package = pkgs.kdePackages.breeze;
      name = "breeze_cursors"; size = 24;
    };
  };
}
