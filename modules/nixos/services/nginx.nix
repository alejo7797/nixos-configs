{
  lib,
  config,
  pkgs,
  ...
}:

let
  cfg = config.myNixOS.nginx;

  protect = ''
    allow 127.0.0.0/8;
    allow ::1/128;

    # Allow VPN access.
    allow 10.20.20.0/24;
    allow fd00::/8;

    # Allow LAN access.
    allow 100.105.183.0/26;

    deny all;
  '';
in

{
  options.myNixOS.nginx.enable = lib.mkEnableOption "nginx";

  config = lib.mkIf cfg.enable {

    services.nginx = {
      enable = true;

      additionalModules = with pkgs.nginxModules; [ fancyindex ];

      commonHttpConfig = ''
        log_format main '$remote_addr - $remote_user [$time_local] '
                        '"$request" $status $body_bytes_sent '
                        '"$http_referer" "$http_user_agent"';
      '';

      resolver.addresses = [ "127.0.0.1" "[::1]" ];

      # Useful settings to enable.
      recommendedOptimisation = true;
      recommendedTlsSettings = true;
      recommendedGzipSettings = true;

      # Useful for reverse proxies.
      recommendedProxySettings = true;

      virtualHosts = {

        "_" = {
          default = true;
          rejectSSL = true;
          extraConfig = ''
            return 444
          '';
        };

        "patchoulihq.cc" = {
          enableACME = true;
          forceSSL = true;

          extraConfig = protect;
          root = "/var/www/html";
        };

      };
    };

    networking.firewall = {
      allowedTCPPorts = [ 80 443 ];
    };

    security.acme.certs."patchoulihq.cc" = {
      extraDomainNames = [ "*.patchoulihq.cc" ];
    };

    sops.secrets = {
      # Cloudflare API key for DNS challenges.
      "acme/cloudflare" = { owner = "acme"; };
    };
  };
}
