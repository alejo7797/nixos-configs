{ lib, pkgs, ... }: {

  services.hypridle.settings =

    let
      hyprlock = lib.getExe pkgs.hyprlock;
      playerctl = lib.getExe pkgs.playerctl;
    in

    {
      general = {
        lock_cmd = "${playerctl} -a pause; ${hyprlock}";
        unlock_cmd = "pkill -USR1 hyprlock";
        before_sleep_cmd = "loginctl lock-session";
      };

      listener = [
        {
          timeout = 600;
          on-timeout = "loginctl lock-session";
        }
        {
          timeout = 720;
          on-timeout = "systemctl suspend";
        }
      ];
    };

}
