{
  lib,
  config,
  ...
}:

let
  cfg = config.my.fcitx5;
in

{
  options.my.fcitx5.enable = lib.mkEnableOption "Fcitx5";

  config = lib.mkIf cfg.enable {

    xdg = {
      configFile = {
        "fcitx5" = {
          source = ./config;
          force = true;
          recursive = true;
        };
      };

      dataFile = {
        "fcitx5" = {
          source = ./data;
          recursive = true;
        };
      };
    };

  };
}
