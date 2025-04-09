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
  };
}
