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
        group = "media";
      };

      # Run Sonarr behind our Nginx web server.
      nginx.virtualHosts."sonarr.patchoulihq.cc" = {

        # Use our wildcard SSL certificate.
        useACMEHost = "patchoulihq.cc"; forceSSL = true;

        extraConfig =
          ''
            # Increased timeout values.
            proxy_read_timeout 10m;
            proxy_send_timeout 10m;
          ''
          # Restrict access to trusted networks.
          + config.myNixOS.nginx.trustedOnly;

        locations."/" = {
          # Proxy to Sonarr running on localhost.
          proxyPass = "http://localhost:8989";
          proxyWebsockets = true;
        };

      };
    };
  };
}
