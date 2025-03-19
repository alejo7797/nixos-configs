{ config,...}: {

  services.my.variety.settings = {

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
        type = "wallhaven"; # Download popular anime wallpapers within the past month.
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

  # Set up my user Zsh config.
  programs.zsh.enable = true;

}
