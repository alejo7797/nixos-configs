{
  lib,
  config,
  pkgs,
  ...
}:

# TODO: secure API key access

let
  cfg = config.myNixOS.unpackerr;

  unpackerrConfig = pkgs.writeText "unpackerr.conf" ''

  '';
in

{
  options.myNixOS.unpackerr.enable = lib.mkEnableOption "Unpackerr";

  config = lib.mkIf cfg.enable {

    systemd.services.unpackerr = {
      description = "Unpackerr Extraction Daemon";
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];

      serviceConfig = {
        Type = "simple";

        User = "unpackerr";
        Group = "media";
        UMask = "0002";

        ExecStart = "${pkgs.unpackerr}/bin/unpackerr -c ${unpackerrConfig}";

        WorkingDirectory = "/tmp";
        Restart = "on-failure";
      };
    };

    users.users.unpackerr = {
      isSystemUser = true;
      group = "media";
    };

  };
}
