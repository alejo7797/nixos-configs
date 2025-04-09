{
  lib,
  config,
  pkgs,
  ...
}:

let
  cfg = config.myHome.graphical;
  ini = pkgs.formats.ini { };
  yaml = pkgs.formats.yaml { };
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
      dolphin.enable = true;
      kitty.enable = true;
      konsole.enable = true;
      mimeApps.enable = true;
      mpv.enable = true;
      ssh.enable = true;
      zathura.enable = true;
    };

    xdg = {
      configFile = {
        "chktexrc".source = ./programs/latex/chktexrc;
        "latexmk/latexmkrc".source = ./programs/latex/latexmkrc;

        "latexindent/latexindent.yaml".source = ./programs/latex/latexindent.yaml;
        "latexindent/indentconfig.yaml".source = yaml.generate "indentconfig.yaml" {
          paths = [ "${config.xdg.configHome}/latexindent/latexindent.yaml" ];
        };

        "baloofilerc".source = ini.generate "baloofilerc" {
          "Basic Settings"."Indexing-Enabled" = false;
        };
        "kwalletrc".source = ini.generate "kwalletrc" {
          "Wallet"."Enabled" = false;
        };
      };
    };

  };
}
