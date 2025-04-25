{ config, lib, ... }:

let
  cfg = config.services.prowlarr;
in

lib.mkIf cfg.enable {

  services.nginx.virtualHosts = {

    "prowlarr.${config.networking.domain}" = {

      my = {
        trustedOnly = true;
        increasedProxyTimeouts = true;
      };

      locations."/" = {
        proxyPass = "http://localhost:9696";
        proxyWebsockets = true;
      };

    };
  };

}
