{
  lib,
  config,
  pkgs,
  ...
}:

let
  cfg = config.myHome.graphical;
in

{
  options.myHome = {

    graphical.enable = lib.mkEnableOption "basic graphical utilities";
    laptop.enable = lib.mkEnableOption "laptop-specific configuration";

    workspaces = lib.mkOption {
      description = "Workspace output assignments.";
      type = with lib.types; attrsOf ( listOf (oneOf [ int str ]) );
      default = { };
      example = {
        "DP-1" = [ "web" "dev" ];
        "eDP-1" = [ "chat" ];
      };
    };
  };

  config = lib.mkIf cfg.enable {

    my.style.enable = true;

    myHome = {
      dolphin.enable = true;
      keepassxc.enable = true;
      kitty.enable = true;
      konsole.enable = true;
      gpg.enable = true;
      mimeApps.enable = true;
      mpv.enable = true;
      ssh.enable = true;
      variety.enable = true;
      zathura.enable = true;
    };

    services = {
      mpris-proxy.enable = true;
      playerctld.enable = true;

      kdeconnect = {
        enable = true;
        indicator = true;
      };
    };

    gtk.gtk2.configLocation = "${config.xdg.configHome}/gtk-2.0/gtkrc";

    home.sessionVariables = {
      CUDA_CACHE_PATH = "${config.xdg.cacheHome}/nv";

      # Environment variables related to math tools and the like.
      DOT_SAGE = "${config.xdg.configHome}/sage"; JUPYTER_PLATFORM_DIRS = 1;
      MATHEMATICA_USERBASE = "${config.xdg.dataHome}/WolframEngine";
      WOLFRAM_USERBASE = "${config.xdg.dataHome}/Wolfram";

      NPM_CONFIG_CACHE = "${config.xdg.cacheHome}/npm";

      RENPY_PATH_TO_SAVES = "${config.xdg.dataHome}/renpy";

      WINEPREFIX = "${config.xdg.dataHome}/wine";

    };

    xdg = {
      configFile = {
        "fcitx5" = {
          source = ./programs/fcitx5/config;
          force = true;
          recursive = true;
        };

        "chktexrc".source = ./programs/latex/chktexrc;
        "latexmk/latexmkrc".source = ./programs/latex/latexmkrc;

        "latexindent/latexindent.yaml".source = ./programs/latex/latexindent.yaml;
        "latexindent/indentconfig.yaml".source = (pkgs.formats.yaml {}).generate "indentconfig.yaml" {
          paths = [ "${config.xdg.configHome}/latexindent/latexindent.yaml" ];
        };

        "baloofilerc".text = lib.generators.toINI {} {
          "Basic Settings"."Indexing-Enabled" = false;
        };
      };

      dataFile = {
        "fcitx5" = {
          source = ./programs/fcitx5/data;
          recursive = true;
        };
      };

      userDirs.enable = true;
    };

    myHome.lib.mkGraphicalService =
      { Unit, Service }:
      {
        Install.WantedBy = [ "graphical-session.target" ];
        Unit = {
          inherit (Unit) Description;
          PartOf = [ "graphical-session.target" ];
          After = [ "graphical-session.target" ];
        };
        inherit Service;
      };
  };
}
