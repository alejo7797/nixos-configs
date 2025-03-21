{
  lib,
  config,
  pkgs,
  ...
}:

let
  cfg = config.myHome.keepassxc;
in

{
  options.myHome.keepassxc.enable = lib.mkEnableOption "KeepassXC";

  config = lib.mkIf cfg.enable {

    home.packages = [ pkgs.keepassxc ];

    systemd.user.services.keepassxc = {
      Unit = {
        Description = "KeepassXC password manager";
        PartOf = [ "graphical-session.target" ];
        After = [ "graphical-session.target" "tray.target" ];
        Wants = [ "tray.target" ];
      };
      Service = {
        ExecStart = "${pkgs.keepassxc}/bin/keepassxc";
      };
      Install = {
        WantedBy = [ "graphical-session.target" ];
      };
    };

    xdg.configFile."keepassxc/keepassxc.ini".source = ./keepassxc.ini;
  };
}
