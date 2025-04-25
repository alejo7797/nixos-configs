{ config, lib, ... }:

let
  cfg = config.services.sonarr;
in

lib.mkIf cfg.enable {

  services = {

    sonarr = {
      group = "media";
    };

    nginx.virtualHosts = {

      "sonarr.${config.networking.domain}" = {

        my = {
          trustedOnly = true;
          increasedProxyTimeouts = true;
        };

        locations."/" = {
          proxyPass = "http://localhost:8989";
          proxyWebsockets = true;
        };

      };

    };
  };

}
