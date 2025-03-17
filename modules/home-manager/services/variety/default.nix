{ config, lib, pkgs, ... }:

let
  cfg = config.my.variety;
in

{
  options.my.variety.enable = lib.mkEnableOption "Variety";

  config = lib.mkIf cfg.enable {

    home.packages = [ pkgs.variety ];

    systemd.user.services.variety = config.myHome.lib.mkGraphicalService {
      Unit.Description = "Variety wallpaper changer";
      Service.ExecStart = "${pkgs.variety}/bin/variety";
    };

    programs.zsh.shellAliases = {
      bgnext = "variety --next";
      bgprev = "variety --previous";
      bgtrash = "variety --trash";
      bgfav = "variety --favorite";
    };

    xdg.configFile."variety/variety.conf".text = lib.generators.toINIWithGlobalSection { } {

      globalSection = {

        change_interval = 28800; # 8 hours.

        set_wallpaper_script = pkgs.writeShellScript "set_wallpaper" (builtins.readFile ./set_wallpaper);
        get_wallpaper_script = pkgs.writeShellScript "get_wallpaper" (builtins.readFile ./get_wallpaper);

        download_folder = "${config.xdg.dataHome}/variety/Downloaded";
        favorites_folder = "${config.home.homeDirectory}/Pictures/Wallpapers/Favourites";
        fetched_folder = "${config.xdg.dataHome}/variety/Fetched";

        download_preference_ratio = 0.8;

      };

      sections.sources = {

        src1 = "True|favorites|The Favorites folder";
        src2 = "True|folder|${config.home.homeDirectory}/Pictures/Wallpapers";

        # Touhou
        src3 = "True|wallhaven|https://wallhaven.cc/search?q=id%3A136&sorting=random";
        src4 = "True|wallhaven|https://wallhaven.cc/search?q=%23Touhou&sorting=random";

        # Anime landscapes
        src5 = "True|wallhaven|https://wallhaven.cc/search?q=id%3A711&categories=010&sorting=random";

        # Legend of Zelda
        src6 = "True|wallhaven|https://wallhaven.cc/search?q=id%3A1777&categories=010&sorting=random";

        # Pokémon
        src7 = "True|wallhaven|https://wallhaven.cc/search?q=id%3A4641&categories=010&sorting=random";

      };
    };
  };
}
