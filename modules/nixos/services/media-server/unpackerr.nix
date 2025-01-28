{
  lib,
  config,
  pkgs,
  ...
}:

let
  cfg = config.myNixOS.unpackerr;

  unpackerrConfig = pkgs.writeText "unpackerr.conf" ''
    [[sonarr]]
    url = "http://localhost:8989"

    [[radarr]]
    url = "http://localhost:6767"
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

        User = "unpackerr"; Group = "media"; UMask = "0002";
        ExecStart = "${pkgs.unpackerr}/bin/unpackerr -c ${unpackerrConfig}";
        EnvironmentFile = config.sops.secrets."unpackerr/env".path;

        WorkingDirectory = "/tmp";
        Restart = "on-failure";
      };
    };

    users.users.unpackerr = {
      isSystemUser = true;
      group = "media";
    };

    sops.secrets = {
      # File containing application API keys.
      "unpackerr/env" = { owner = "unpackerr"; };
    };
  };
}
