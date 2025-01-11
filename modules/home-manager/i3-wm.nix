{
  lib,
  config,
  pkgs,
  ...
}:

let
  cfg = config.myHome.i3;
in

{
  options.myHome.i3.enable = lib.mkEnableOption "i3 configuration";

  config = lib.mkIf cfg.enable {

    systemd.user = {
      services = {
        lockbg-cache = {
          Unit.Description = "Cache the lockscreen wallpaper";
          Service = {
            Type = "oneshot";
            ExecStart = "${pkgs.lockbg-cache}/bin/lockbg-cache";
          };
        };
      };

      timers = {
        lockbg-cache = {
          Unit.Description = "Cache the lockscreen wallpaper every 10 minutes";
          Timer = {
            OnBootSec = "10min";
            OnUnitActiveSec = "10min";
          };
          Install.WantedBy = "timers.target";
        };
      };
    };
  };
}
