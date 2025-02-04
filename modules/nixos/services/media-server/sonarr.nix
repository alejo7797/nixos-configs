{
  lib,
  config,
  ...
}:

let
  cfg = config.myNixOS.sonarr;
in

{
  options.myNixOS.sonarr.enable = lib.mkEnableOption "Sonarr";

  config = lib.mkIf cfg.enable {

    services = {

      sonarr = {
        enable = true;

        # We ensure the media group exists.
        group = config.users.groups.media.name;
      };

      # Run Plex behind our Nginx web server.
      nginx.virtualHosts."sonarr.patchoulihq.cc" = {

        # Use our wildcard certificate.
        useACMEHost = "patchoulihq.cc"; forceSSL = true;

        extraConfig = ''
          proxy_read_timeout 10m;
          proxy_send_timeout 10m;
        '';

        locations."/" = {
          # Proxy to Sonarr running on localhost.
          proxyPass = "http://localhost:8989";
          proxyWebsockets = true;
        };

      };
    };
  };
}
