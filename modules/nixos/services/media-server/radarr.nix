{ config, lib, ... }:

let
  cfg = config.services.radarr;
in

lib.mkIf cfg.enable {

  services = {

    radarr = {
      group = "media";
    };

    nginx.virtualHosts = {

      "radarr.${config.networking.domain}" = {

        my = {
          trustedOnly = true;
          increasedProxyTimeouts = true;
        };

        locations."/" = {
          proxyPass = "http://localhost:7878";
          proxyWebsockets = true;
        };

      };

    };
  };

}
