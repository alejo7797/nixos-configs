{
  lib,
  config,
  pkgs,
  ...
}:

let
  cfg = config.myNixOS.kometa;
in

{
  options.myNixOS.kometa = {
    enable = lib.mkEnableOption "Kometa";

    home = lib.mkOption {
      description = "Kometa runtime directory.";
      type = lib.types.str;
      default = "/var/lib/kometa";
    };
  };

  config = lib.mkIf cfg.enable {

    systemd.services.kometa = {

      description = "Kometa Plex Metadata Manager";
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];

      environment = {
        LC_ALL = "C.UTF-8";
        LANG = "C.UTF-8";
        TZ = config.time.timeZone;
      };

      serviceConfig = {
        Type = "simple";

        User = "kometa"; Group = "media";
        ExecStart = "${pkgs.kometa}/bin/kometa -c ${cfg.home}/config.yml";
        EnvironmentFile = config.sops.secrets."kometa/env".path;

        Restart = "on-failure";
      };
    };


    users.users.kometa = {
      inherit (cfg) home;
      isSystemUser = true;

      # We ensure the media group exists.
      group = config.users.groups.media.name;
    };

    sops.secrets = {
      # File containing API keys and credentials.
      "kometa/env" = { owner = "kometa"; };
    };
  };
}
