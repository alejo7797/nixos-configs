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

      BUNDLE_USER_CONFIG = "${config.xdg.configHome}/bundle";
      BUNDLE_USER_CACHE = "${config.xdg.cacheHome}/bundle";
      BUNDLE_USER_PLUGIN = "${config.xdg.dataHome}/bundle";

      CUDA_CACHE_PATH = "${config.xdg.cacheHome}/nv";

      DOT_SAGE = "${config.xdg.configHome}/sage";

      NPM_CONFIG_INIT_MODULE = "${config.xdg.configHome}/npm/config/npm-init.js";
      NPM_CONFIG_CACHE = "${config.xdg.cacheHome}/npm";
      NPM_CONFIG_TMP = "$XDG_RUNTIME_DIR/npm";

      RENPY_PATH_TO_SAVES="${config.xdg.dataHome}/renpy";

      WINEPREFIX="${config.xdg.dataHome}/wine";
    };

    xdg.configFile = {
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

    xdg.dataFile = {
      "fcitx5" = {
        source = ./programs/fcitx5/data;
        recursive = true;
      };
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
