# Not available in release-24.11.

{ pkgs, lib, config, ... }:

let
  cfg = config.services.syncthing;
  install = "${pkgs.coreutils}/bin/install";
in

{

  options.services.syncthing = {

    cert = lib.mkOption {
      type = lib.types.nullOr lib.types.str;
      default = null;
      description = ''
        Path to the `cert.pem` file, which will be copied into Syncthing's config directory.
      '';
    };

    key = lib.mkOption {
      type = lib.types.nullOr lib.types.str;
      default = null;
      description = ''
        Path to the `key.pem` file, which will be copied into Syncthing's config directory.
      '';
    };
  };

  config.systemd.user.services.syncthing = {
    Service = {
      ExecStartPre = lib.mkIf (cfg.cert != null || cfg.key != null) "+${
        pkgs.writers.writeBash "syncthing-copy-keys" ''
          syncthing_dir="''${XDG_CONFIG_HOME:-$HOME/.config}/syncthing"
          ${install} -dm700 "$syncthing_dir"
          ${lib.optionalString (cfg.cert != null) ''
            ${install} -Dm400 ${ toString cfg.cert } "$syncthing_dir/cert.pem"
          ''}
          ${lib.optionalString (cfg.key != null) ''
            ${install} -Dm400 ${ toString cfg.key } "$syncthing_dir/key.pem"
          ''}
        ''
      }";
    };
  };
}
