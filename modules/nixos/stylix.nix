{ inputs, pkgs, ... }: {

  imports = [ inputs.stylix.nixosModules.stylix ];

  stylix = {

    image = builtins.fetchurl {
      # The 24.11 release of Stylix makes us specify a wallpaper image.
      url = "https://w.wallhaven.cc/full/zy/wallhaven-zye9ry.jpg";
      sha256 = "16d5pch4544knygndsslmh682fxp6sqwn5b9vnrb35ji7m5zfcm0";
    };

    # My favourite colour scheme https://github.com/chriskempson/tomorrow-theme.
    base16Scheme = "${pkgs.base16-schemes}/share/themes/tomorrow-night.yaml";

    # Enable dark mode.
    polarity = "dark";

    fonts = rec {
      sizes = {
        # At DPI = 120.
        applications = 10;
        terminal = 11;
      };

      sansSerif = {
        # A pleasant default font.
        package = pkgs.noto-fonts;
        name = "Noto Sans";
      };

      # Why would I not?
      serif = sansSerif;

      monospace = {
        # Monospace font of choice.
        package = pkgs.nerd-fonts.hack;
        name = "Hack Nerd Font";
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
