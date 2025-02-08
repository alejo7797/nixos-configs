{
  lib,
  config,
  ...
}:

let
  cfg = config.myNixOS.prowlarr;
in

{
  options.myNixOS.prowlarr.enable = lib.mkEnableOption "Prowlarr";

  config = lib.mkIf cfg.enable {

    services = {

      # Enable Prowlarr.
      prowlarr.enable = true;

      # Run Prowlarr behind our Nginx web server.
      nginx.virtualHosts."prowlarr.patchoulihq.cc" = {

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
          # Proxy to Radarr running on localhost.
          proxyPass = "http://localhost:9696";
          proxyWebsockets = true;
        };

      };
    };
  };
}
