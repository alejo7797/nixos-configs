{
  lib,
  config,
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

    myHome = {
      keepassxc.enable = true;
      kitty.enable = true;
      gpg.enable = true;
      mimeApps.enable = true;
      mpv.enable = true;
      ssh.enable = true;
      style.enable = true;
      variety.enable = true;
      zathura.enable = true;
    };

    services = {
      mpris-proxy.enable = true;
      playerctld.enable = true;
      xsettingsd.enable = true;

      kdeconnect = {
        enable = true;
        indicator = true;
      };
    };

    xdg.configFile = {
      "fcitx5" = {
        source = ./programs/fcitx5/config;
        force = true;
        recursive = true;
      };

      "chktexrc".source = ./programs/latex/chktexrc;
      "latexmk/latexmkrc".source = ./programs/latex/latexmkrc;
      "rubocop/config.yml".source = ./programs/rubocop/config.yml;

      "baloofilerc".text = ''
        [Basic Settings]
        Indexing-Enabled=false
      '';
    };

    xdg.dataFile = {
      "fcitx5" = {
        source = ./programs/fcitx5/data;
        recursive = true;
      };
    };

    myHome.lib.mkGraphicalService =
      { Unit, Service }: {
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
