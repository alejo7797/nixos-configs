{ config, ... }:
{

  programs = {

    git = {
      # Set basic Git identity.
      userEmail = "alex@epelde.net";
      userName = "Alex Epelde";
    };

    gpg.publicKeys = [
      {
        source = builtins.fetchurl {
          url = "https://alex.epelde.net/public-key.asc"; # My public key.
          sha256 = "1mijaxbqrc5mbwm9npbaf1vk8zbrrv3f4fc956kj98j7phb284gh";
        };

        # It's my key, lol.
        trust = "ultimate";
      }
    ];

    # Set up Z shell.
    zsh.enable = true;

  };

  services = {

    my.variety.settings = {

      # Change every 8 hours.
      changeInterval = 28800;

      sources = {

        local = {
          type = "folder"; # Wallpapers I have saved on my computer.
          url = "${config.home.homeDirectory}/Pictures/Wallpapers";
        };

        touhou = {
          type = "wallhaven"; # Download new wallpapers tagged '#Touhou'.
          url = "https://wallhaven.cc/search?q=id%3A136&sorting=random";
        };

        landscapes = {
          type = "wallhaven"; # Download new anime wallpapers with the tag '#landscape'.
          url = "https://wallhaven.cc/search?q=id%3A711&categories=010&sorting=random";
        };

        toplist = {
          type = "wallhaven"; # Download anime wallpapers popular within the past month.
          url = "https://wallhaven.cc/search?categories=010&topRange=1M&sorting=toplist";
        };

        pokemon = {
          type = "wallhaven"; # Download new anime wallpapers with the tag '#Pokémon'.
          url = "https://wallhaven.cc/search?q=id%3A4641&categories=010&sorting=random";
        };

        zelda = {
          type = "wallhaven"; # Download new wallpapers tagged '#The Legend of Zelda'.
          url = "https://wallhaven.cc/search?q=id%3A1777&categories=010&sorting=random";
        };

      };

    };

  };

}
