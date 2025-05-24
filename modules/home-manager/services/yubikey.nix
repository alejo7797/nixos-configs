{ config, lib, pkgs, ... }:

let
  cfg = config.services.my.yubikey;
in

{
  options.services.my.yubikey = {

    enable = lib.mkEnableOption "YubiKey user actions";

    safebox-plain = lib.mkOption {
      type = lib.types.str; description = "Path to open safebox.";
      default = "${config.home.homeDirectory}/Documents/Safebox";
    };

    safebox-cipher = lib.mkOption {
      type = lib.types.str; description = "Path to encrypted safebox.";
      default = "${config.xdg.dataHome}/syncthing/safebox";
    };

  };

  config = lib.mkIf cfg.enable {

    home.packages = [(

      pkgs.writeShellScriptBin "safebox-open" ''

        ${lib.getExe' pkgs.gocryptfs "gocryptfs"}  -fido2 \
          $(${lib.getExe' pkgs.libfido2 "fido2-token"} -L | cut -f 1 -d ":") \
          ${cfg.safebox-cipher} ${cfg.safebox-plain}

      ''

    )];

    systemd.user.services.yubikey-actions = {

      Unit = {
        Description = "YubiKey user action manager";
        StopPropagatedFrom = "dev-yubikey.device";
      };

      Install = {
        WantedBy = [ "dev-yubikey.device" ];
      };

      Service = {
        # Service logic.
        RemainAfterExit = true;
        Type = "oneshot";

        ExecStop = [

          # Kill gnucash so that the following works.
          "-${lib.getExe' pkgs.procps "pkill"} gnucash"

          # Unmount user's gocryptfs safebox on YubiKey removal.
          "-/run/wrappers/bin/fusermount -u ${cfg.safebox-plain}"

        ];
      };

    };

  };
}
