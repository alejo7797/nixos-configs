{
  lib,
  config,
  pkgs,
  ...
}:

let
  cfg = config.myNixOS.plex;
in

{
  options.myNixOS.plex.enable = lib.mkEnableOption "Plex Media Server";

  config = lib.mkIf cfg.enable {

    services = {

      plex = {
        enable = true;
        group = "media";
      };

      # Run Plex behind our Nginx web server.
      nginx.virtualHosts."plex.patchoulihq.cc" = {

        # Use our wildcard certificate.
        useACMEHost = "patchoulihq.cc"; forceSSL = true;

        extraConfig = ''

          # More compression.
          gzip_proxied any;
          gzip_disable "msie6";

          # Buffering off.
          proxy_buffering off;

          # Headers for the WebSocket connection.
          proxy_set_header Sec-WebSocket-Extensions $http_sec_websocket_extensions;
          proxy_set_header Sec-WebSocket-Key $http_sec_websocket_key;
          proxy_set_header Sec-WebSocket-Version $http_sec_websocket_version;

        '';

        locations."/" = {
          # Proxy to Plex running on localhost.
          proxyPass = "https://localhost:32400";
          proxyWebsockets = true;
        };

      };
    };

    systemd.services = {

      plex-cleanup = {
        description = "Plex PhotoTranscoder Cache Cleanup";
        script = ''
          # With this command we keep the PhotoTranscoder cache at a reasonable size, deleting old files that are not needed anymore to save space.
          ${pkgs.findutils}/bin/find ${config.services.plex.dataDir}/Plex\ Media\ Server/Cache/PhotoTranscoder -name '*.jpg' -type f -mtime +5 -delete
        '';
        startAt = "09:00";
      };

    };
  };
}
