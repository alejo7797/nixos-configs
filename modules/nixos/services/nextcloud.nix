{ config, lib, ... }:

let
  cfg = config.services.nextcloud;
in

lib.mkIf cfg.enable {

  services = {

    nextcloud = {
      https = true;

      # Memory cache support.
      configureRedis = true;

      # Use a local MySQL database.
      database.createLocally = true;
      config.dbtype = "mysql";

      # Miscellaneous goodies.
      autoUpdateApps.enable = true;
      notify_push.enable = true;

      config = {
        # Secure and declarative admin user password with sops-nix.
        adminpassFile = config.sops.secrets.nextcloud-admin.path;
      };
    };

    mysql.settings.mysqld = {
      innodb_file_per_table = true;
      innodb_file_format = "barracuda";
      innodb_large_prefix = true;
    };

  };

  sops.secrets = with config.users.users; {
    "nextcloud/admin" = { owner = nextcloud.name; };
    "nextcloud/extra" = { owner = nextcloud.name; };
  };
}
