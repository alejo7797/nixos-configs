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

    systemd.user.services.keepassxc = config.myHome.lib.mkGraphicalService {
      Unit.Description = "KeepassXC password manager";
      Service = {
        # Prevent quirks with KeepassXC when it starts too early.
        ExecStartPre = "${pkgs.coreutils}/bin/sleep 5";
        ExecStart = "${pkgs.keepassxc}/bin/keepassxc";
      };
    };

    xdg.configFile."keepassxc/keepassxc.ini".source = ./keepassxc.ini;
  };
}
