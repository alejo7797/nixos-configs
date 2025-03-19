{ config,...}: {

  my = {

    variety.settings = {
      changeInterval = 28800;

      sources = {

        local = {
          type = "folder";
          uri = "${config.home.homeDirectory}/Pictures/Wallpapers";
        };

        touhou1 = {
          type = "wallhaven";
          uri = "https://wallhaven.cc/search?q=id%3A136&sorting=random";
        };

        touhou2 = {
          type = "wallhaven";
          uri = "https://wallhaven.cc/search?q=%23Touhou&sorting=random";
        };

        landscapes = {
          type = "wallhaven";
          uri = "https://wallhaven.cc/search?q=id%3A711&categories=010&sorting=random";
        };

        zelda = {
          type = "wallhaven";
          uri = "https://wallhaven.cc/search?q=id%3A1777&categories=010&sorting=random";
        };

        pokemon = {
          type = "wallhaven";
          uri = "https://wallhaven.cc/search?q=id%3A4641&categories=010&sorting=random";
        };
      };
    };

  };

  programs.zsh.enable = true;

}
