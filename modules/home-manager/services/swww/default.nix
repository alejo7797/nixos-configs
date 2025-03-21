{ config, lib, pkgs, ... }:

let
  cfg = config.services.my.swww;
in

{
  options = {

    services.my.swww = {

      enable = lib.mkEnableOption "swww";
      package = lib.mkPackageOption pkgs "swww" { };

    };

  };

  config = lib.mkIf cfg.enable {

    home.packages = [ cfg.package ];

    systemd.user.services.swww = {
      Unit = {
        ConditionEnvironment = "WAYLAND_DISPLAY";
        Description = "swww wallpaper daemon";
        PartOf = [ "graphical-session.target" ];
        After = [ "graphical-session.target" ];
      };
      Service = {
        ExecStart = lib.getExe' cfg.package "swww-daemon";
        Restart = "on-failure";
      };
      Install.WantedBy = [ "graphical-session.target" ];
    };

  };
}
