{
  lib,
  config,
  ...
}:

let
  cfg = config.myNixOS.radarr;
in

{
  options.myNixOS.radarr.enable = lib.mkEnableOption "Radarr";

  config = lib.mkIf cfg.enable {

    services = {

      radarr = {
        enable = true;
        group = "media";
      };

      # Run Radarr behind our Nginx web server.
      nginx.virtualHosts."radarr.patchoulihq.cc" = {

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
          proxyPass = "http://localhost:7878";
          proxyWebsockets = true;
        };

      };
    };
  };
}
