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

        settings = {
          # System email configuration.
          mail_smtphost = "mail.patchoulihq.cc";
        };

        # Admin user password and other sensitive Nextcloud secrets.
        config.adminpassFile = config.sops.secrets."nextcloud/admin".path;
        secretFile = config.sops.secrets."nextcloud/extra".path;
      };

      mysql.settings = {
        mysqld = {
          # For utf8mb4 support.
          innodb_large_prefix = true;
          innodb_file_format = "barracuda";
          innodb_file_per_table = true;
        };
      };

      nginx.virtualHosts."cloud.patchoulihq.cc" = {
        # Use our wildcard SSL certificate.
        useACMEHost = "patchoulihq.cc"; forceSSL = true;
      };
    };

    sops.secrets = {
      # File containing config secrets.
      "nextcloud/admin" = { owner = "nextcloud"; };
      "nextcloud/extra" = { owner = "nextcloud"; };
    };
  };
}
