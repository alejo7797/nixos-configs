{
  lib,
  config,
  pkgs,
  ...
}:

let
  cfg = config.myHome.borgmatic;
in

{
  options.myHome.borgmatic.enable = lib.mkEnableOption "Borgmatic";

  config = lib.mkIf cfg.enable {

    programs.borgmatic.enable = true;

    systemd.user = {
      services.borgmatic = {
        Unit = {
          Description = "Borgmatic backup";
          ConditionACPower = true;
        };
        Service = {
          Type = "oneshot";
          RuntimeDirectory = "borgmatic";
          StateDirectory = "borgmatic";

          # Lower CPU and I/O priority.
          Nice = 19 ;IOWeight = 100;
          CPUSchedulingPolicy = "batch";
          IOSchedulingClass = "best-effort";
          IOSchedulingPriority = 7;

          Restart = "no"; LogRateLimitIntervalSec = 0;

          # Prevent backups running during boot.
          ExecStartPre = "${pkgs.coreutils}/bin/sleep 1m";

          ExecStart = ''
            ${pkgs.systemd}/bin/systemd-inhibit \
            --who="borgmatic" --what="sleep:shutdown" \
            --why="Prevent interrupting scheduled backup" \
            ${pkgs.borgmatic}/bin/borgmatic \
            --verbosity -2 --syslog-verbosity 1
          '';
        };
      };

      timers.borgmatic = {
        Unit = {
          Description = "Run Borgmatic backup daily";
        };
        Timer = {
          OnCalendar = "daily";
          Persistent = true;
          RandomizedDelaySec = "3h";
        };
        Install = {
          WantedBy = [ "timers.target" ];
        };
      };
    };
  };
}
