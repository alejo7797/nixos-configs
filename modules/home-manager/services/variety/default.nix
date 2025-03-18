{ config, lib, pkgs, ... }:

let
  cfg = config.my.variety;
in

{
  options = {

    my.variety = {

      enable = lib.mkEnableOption "Variety";
      package = lib.mkPackageOption pkgs "variety" { nullable = true; };

      settings = lib.mkOption {
        description = "Variety configuration.";
        type = with lib.types; submodule {
          options = {
            changeInterval = lib.mkOption {
              description = "Interval of time at which to change the wallpaper.";
              type = int;
              default = "3600";
            };
            downloadPreferenceRatio = lib.mkOption {
              description = "How often to use newly downloaded wallpapers.";
              type = float;
              default = 0.5;
            };
            favoritesFolder = lib.mkOption {
              description = "Folder to keep favorited wallpapers in.";
              type = str;
              default = "${config.home.homeDirectory}/Pictures/Wallpapers/Favorites";
            };
            sources = lib.mkOption {
              description = "Wallpaper sources.";
              type = attrsOf (submodule {
                options = {
                  type = lib.mkOption {
                    description = "Source type.";
                    type = enum [ "image" "favorites" "folder" "wallhaven" ];
                  };
                  uri = lib.mkOption {
                    description = "Source URI";
                    type = str;
                  };
                };
              });
            };
          };
        };
      };

    };

  };

  config = lib.mkIf cfg.enable {

    my.swww.enable = config.my.wayland.enable;

    # TODO: move somewhere
    my.variety.settings = {
      changeInterval = 28800;
      sources = {
        favorites = {
          type = "favorites";
          uri = "The Favorites folder";
        };

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

    home.packages = [ cfg.package pkgs.feh ];

    systemd.user.services.variety = {
      Unit = {
        Description = "Variety wallpaper changer";
        PartOf = [ "graphical-session.target" ];
        After = [ "graphical-session.target" "swww.service" ];
        X-Restart-Triggers = [ config.xdg.configFile."variety/variety.conf".source ];
      };
      Service = {
        ExecStart = lib.getExe pkgs.variety;
        Restart = "on-failure";
      };
      Install.WantedBy = [ "graphical-session.target" ];
    };

    home.shellAliases = {
      bgnext = "variety --next";
      bgprev = "variety --previous";
      bgtrash = "variety --trash";
      bgfav = "variety --favorite";
    };

    xdg.configFile."variety/variety.conf".text = lib.generators.toINIWithGlobalSection { } {

      globalSection = {

        change_interval = cfg.settings.changeInterval;

        set_wallpaper_script = pkgs.writeShellScript "set_wallpaper" (builtins.readFile ./set_wallpaper);
        get_wallpaper_script = pkgs.writeShellScript "get_wallpaper" (builtins.readFile ./get_wallpaper);

        download_folder = "${config.xdg.dataHome}/variety/Downloaded";
        favorites_folder = cfg.settings.favoritesFolder;
        fetched_folder = "${config.xdg.dataHome}/variety/Fetched";

        download_preference_ratio = cfg.settings.downloadPreferenceRatio;

      };

      sections.sources = builtins.mapAttrs (
        _: value: "True|${value.type}|${value.uri}"
      ) cfg.settings.sources;
    };
  };
}
