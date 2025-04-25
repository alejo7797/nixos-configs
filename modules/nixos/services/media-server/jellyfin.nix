{ config, lib, ... }:

let
  cfg = config.services.jellyfin;
in

lib.mkIf cfg.enable {

  services = {

    jellyfin = {
      group = "media";
    };

    nginx.virtualHosts = {

      "jellyfin.${config.networking.domain}" = {

          extraConfig = ''
            add_header X-Content-Type-Options "nosniff";

            add_header Permissions-Policy "accelerometer=(), ambient-light-sensor=(), battery=(), bluetooth=(), camera=(), clipboard-read=(), display-capture=(), document-domain=(), encrypted-media=(), gamepad=(), geolocation=(), gyroscope=(), hid=(), idle-detection=(), interest-cohort=(), keyboard-map=(), local-fonts=(), magnetometer=(), microphone=(), payment=(), publickey-credentials-get=(), serial=(), sync-xhr=(), usb=(), xr-spatial-tracking=()" always;

            add_header Content-Security-Policy "default-src https: data: blob: ; img-src 'self' https://* ; style-src 'self' 'unsafe-inline'; script-src 'self' 'unsafe-inline' https://www.gstatic.com https://www.youtube.com blob:; worker-src 'self' blob:; connect-src 'self'; object-src 'none'; frame-ancestors 'self'; font-src 'self'";
          '';

          locations."/" = {
            proxyPass = "http://localhost:8096";
            extraConfig = ''
              proxy_buffering off;
            '';
          };

          locations."/socket" = {
            proxyPass = "http://localhost:8096";
            proxyWebsockets = true;
          };

      };

    };

  };

}
