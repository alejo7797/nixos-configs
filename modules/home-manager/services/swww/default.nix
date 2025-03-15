{
  lib,
  config,
  pkgs,
  ...
}:

let
  cfg = config.my.swww;
in

{
  options.my.swww.enable = lib.mkEnableOption "swww";

  config = lib.mkIf cfg.enable {

    systemd.user.services.swww = config.myHome.lib.mkGraphicalService {
      Unit.Description = "swww wallpaper daemon";
      Service.ExecStart = "${pkgs.swww}/bin/swww-daemon";
    };

  };
}
