{ config, lib, ... }:

let
  cfg = config.services.nextcloud;
in

lib.mkIf cfg.enable {

  services = {

    nextcloud = {
      https = true;

      # My very own self-hosted Nextcloud instance.
      hostName = "cloud.${config.networking.domain}";

      # Memory cache support.
      configureRedis = true;

      # Use a local MySQL database.
      database.createLocally = true;
      config.dbtype = "mysql";

      # Miscellaneous goodies.
      autoUpdateApps.enable = true;
      notify_push.enable = true;

      settings = {
        # Nextcloud system email configuration.
        mail_smtphost = "mail.patchoulihq.cc";
      };

      # Admin user password and other sensitive Nextcloud secrets.
      config.adminpassFile = config.sops.secrets."nextcloud/admin".path;
      secretFile = config.sops.secrets."nextcloud/extra".path;
    };

    mysql.settings = {
      mysqld = {
        innodb_file_per_table = true;
        innodb_file_format = "barracuda";
        innodb_large_prefix = true;
      };
    };

  };

  sops.secrets = with config.users.users; {
    "nextcloud/admin" = { owner = nextcloud.name; };
    "nextcloud/extra" = { owner = nextcloud.name; };
  };
}
