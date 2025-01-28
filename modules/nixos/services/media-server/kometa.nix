{
  lib,
  config,
  ...
}:

let
  cfg = config.myNixOS.kometa;
in

{
  options.myNixOS.kometa.enable = lib.mkEnableOption "Kometa & ImageMaid";

  config = lib.mkIf cfg.enable {

    virtualisation.oci-containers.containers = {

      kometa = {
        image = "kometateam/kometa";

        volumes = [ "/var/lib/kometa:/config" ];
        environment = { TZ = "America/New_York"; };

        environmentFiles = [
          # File containing API keys and such.
          config.sops.secrets."kometa/env".path
        ];
      };

      imagemaid = {
        image = "kometateam/imagemaid";

        volumes = [
          "/var/lib/imagemaid:/config"
          "/var/lib/plex/Plex Media Server:/plex"
        ];

        environment = { TZ = "America/New_York"; };

        environmentFiles = [
          # File containing API keys and such.
          config.sops.secrets."imagemaid/env".path
        ];
      };

    };

    sops.secrets = {
      "kometa/env" = { };
      "imagemaid/env" = { };
    };
  };
}
