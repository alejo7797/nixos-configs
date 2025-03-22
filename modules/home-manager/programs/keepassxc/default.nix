{ config, lib, pkgs, ... }:

let
  cfg = config.programs.my.keepassxc;
in

{
  options.programs.my.keepassxc = {

    enable = lib.mkEnableOption "KeepassXC";
    package = lib.mkPackageOption pkgs "keepassxc" { };

  };

  config = lib.mkIf cfg.enable {

    home.packages = [ cfg.package ];

    systemd.user.services.keepassxc = {
      Unit = {
        Description = "KeepassXC password manager";
        PartOf = [ "graphical-session.target" ];
        After = [ "graphical-session.target" "tray.target" ];
        Wants = [ "tray.target" ];
      };
      Service = {
        ExecStart = lib.getExe cfg.package;
      };
      Install = {
        WantedBy = [ "graphical-session.target" ];
      };
    };

    xdg.configFile."keepassxc/keepassxc.ini".source = ./keepassxc.ini;
  };
}
