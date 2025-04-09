{ config, lib, pkgs, ... }:

let
  cfg = config.programs.my.dolphin;
  ini = pkgs.formats.ini { };
in

{
  options.programs.my.dolphin.enable = lib.mkEnableOption "Dolphin";

  config = lib.mkIf cfg.enable {

    xdg.configFile = {

      dolphinrc.source = ini.generate "dolphinrc" {

        DetailsMode = {
          IconSize = 22;
          PreviewSize = 22;
          SidePadding = 21;
        };

        "KFileDialog Settings" = {
          "Places Icons Auto-resize" = false;
          "Places Icons Static Size" = 22;
        };

        MainWindow = {
          MenuBar = "Disabled";
          ToolBarsMovable = "Disabled";
        };

      };

      konsolerc.source = ini.generate "konsolerc" {
        "Desktop Entry".DefaultProfile = "Default.profile";
      };

      arkrc.source = ini.generate "arkrc" {
        General.defaultOpenAction = "Open";
      };

      ktrashrc.source = ini.generate "ktrashrc" {
        "${config.xdg.dataHome}/Trash" = {
          UseTimeLimit = true; Days = 7;
        };
      };

      baloofilerc.source = ini.generate "baloofilerc" {
        "Basic Settings"."Indexing-Enabled" = false;
      };

      kwalletrc.source = ini.generate "kwalletrc" {
        "Wallet"."Enabled" = false;
      };

    };

    xdg.dataFile = {

      "konsole/Default.profile".text = ini.generate "Default.profile" {

        General.Name = "Default";

        Appearance = with config.stylix.fonts; {
          ColorScheme = "TomorrowNight"; # Custom implementation of Tomorrow Night for Konsole.
          Font = "${monospace.name},${toString sizes.applications},-1,5,400,0,0,0,0,0,0,0,0,0,0,1";
        };

      };

      "konsole/TomorrowNight.colorscheme".source = ./colorscheme;

    };

  };
}
