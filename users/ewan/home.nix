{ config, ... }:
{

  programs = {

    firefox.profiles."ewan.default" = {

      # Set my Firefox profile's New Tab page.
      settings."browser.newtabpage.pinned" = [
        {
          label = "youtube"; # Watch vids.
          url = "https://www.youtube.com";
        }
        {
          label = "wanikani"; # 日本語です。
          url = "https://www.wanikani.com";
        }
        {
          label = "patchouli"; # My home.
          url = "https://patchoulihq.cc";
        }
        {
          label = "cloud"; url = "https://cloud.patchoulihq.cc"; # My cloud.
          customScreenshotURL = "https://patchoulihq.cc/nextcloud-logo.png";
        }
        {
          label = "arxiv"; baseDomain = "arxiv.org";
          url = "https://arxiv.org/list/math.GT/recent";
        }
        {
          label = "ae433"; baseDomain = "alex.epelde.net"; # Me!
          url = "https://alex.epelde.net/about-to-get-very-silly";
        }
        {
          label = "nixos"; url = "https://search.nixos.org"; # NixOS.
          customScreenshotURL = "https://patchoulihq.cc/nix-logo.png";
        }
        {
          label = "patreon"; # Keep it up.
          url = "https://www.patreon.com";
        }
      ];

    };

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

    # Load full config.
    zsh.enable = true;

  };

  services = {

    my.jellyfin-rpc = {

      settings.jellyfin = {
        url = "https://jellyfin.patchoulihq.cc";
        username = [ "ewan" ]; # Basic config.
      };

      # File containing Jellyfin API key and other stuff.
      secretsFile = config.sops.secrets.jellyfin-rpc.path;

    };

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

  sops.secrets = {

    jellyfin-rpc = { };

  };

}
