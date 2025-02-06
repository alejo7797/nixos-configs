{
  lib,
  config,
  ...
}:

let
  cfg = config.myNixOS.nextcloud;
in

{
  options.myNixOS.nextcloud.enable = lib.mkEnableOption "Nextcloud server";

  config = lib.mkIf cfg.enable {

    services = {

      nextcloud = {
        enable = true;
        https = true;

        # It's my very own Nextcloud.
        hostName = "cloud.patchoulihq.cc";

        # Caching support.
        configureRedis = true;

        # Use a MySQL database.
        config.dbtype = "mysql";
        database.createLocally = true;

        # Miscellaneous goodies.
        autoUpdateApps.enable = true;
        notify_push.enable = true;

        # Password salt and other secrets management.
        secretFile = config.sops.secrets."nextcloud".path;
      };

      nginx.virtualHosts."cloud.patchoulihq.cc" = {
        # Use our wildcard SSL certificate.
        useACMEHost = "patchoulihq.cc"; forceSSL = true;
      };
    };

    sops.secrets = {
      # File containing config secrets.
      "nextcloud" = { owner = "nextcloud"; };
    };
  };
}
