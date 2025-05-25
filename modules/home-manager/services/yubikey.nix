{ config, lib, pkgs, ... }:

let
  cfg = config.services.my.yubikey;

  fuser = lib.getExe' pkgs.psmisc "fuser";

  safebox-open = pkgs.writeShellScriptBin "safebox-open" ''

    ${lib.getExe' pkgs.gocryptfs "gocryptfs"} -fido2 \
      $(${lib.getExe' pkgs.libfido2 "fido2-token"} -L | cut -f 1 -d ":") \
      ${cfg.safebox-cipher} ${cfg.safebox-plain}

  '';

  safebox-close = pkgs.writeShellScriptBin "safebox-close" ''

    # Test to see if the user's safebox is open before invoking fusermount for real.
    if ${lib.getExe' pkgs.util-linux "mount"} | grep -q ${cfg.safebox-plain}; then

      # Terminate processes using gocryptfs mount.
      ${fuser} -s -m ${cfg.safebox-plain} -k -TERM

      # Annoyingly there is some delay before the bottom works out.
      while ${fuser} -s -m ${cfg.safebox-plain}; do sleep 0.1; done

      # Note: the fusermount binary has the setuid bit set.
      /run/wrappers/bin/fusermount -u ${cfg.safebox-plain}

    fi

  '';
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

    home.packages = [ safebox-open safebox-close ];

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

        # Fall back to my custom locking system.
        ExecStop = [ (lib.getExe safebox-close) ];

      };

    };

  };
}
