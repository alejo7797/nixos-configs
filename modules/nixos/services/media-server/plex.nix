{
  lib,
  config,
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

        # We ensure the media group exists.
        group = config.users.groups.media.name;
      };

      # Run Plex behind our Nginx web server.
      nginx.virtualHosts."plex.patchoulihq.cc" = {

        # Generate an SSL certificate.
        enableACME = true; forceSSL = true;

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
  };
}
