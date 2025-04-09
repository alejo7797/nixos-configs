{ config, lib, ... }:

let
  cfg = config.programs.my.fcitx5;
in

{
  options.programs.my.fcitx5.enable = lib.mkEnableOption "Fcitx5";

  config = lib.mkIf cfg.enable {

    xdg = {
      configFile.fcitx5 = {
        source = ./conf;
        recursive = true;
        force = true;
      };

      dataFile.fcitx5 = {
        recursive = true;
        source = ./data;
      };
    };

  };
}
