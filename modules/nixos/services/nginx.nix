{
  lib,
  config,
  pkgs,
  ...
}:

let
  cfg = config.myNixOS.nginx;
in

{
  options.myNixOS.nginx = {
    enable = lib.mkEnableOption "nginx";

    trustedNetworks = lib.mkOption {
      type = with lib.types; listOf str;
      default = [ "127.0.0.0/8" "::1/128" ];
      description = ''
        Networks that are allowed access to virtual hosts
        which are protected by the `trustedOnly` option.
      '';
    };

    trustedOnly = lib.mkOption {
      type = lib.types.str;
      description = ''
        Nginx configuration restricting access to this
        virtual host only to configured trusted networks.
      '';
    };
  };

  config = lib.mkIf cfg.enable {

    myNixOS.nginx.trustedOnly =
      # Here we allow access to hosts from trusted networks and deny everyone else.
      lib.concatStrings (map (net: "allow ${net};") cfg.trustedNetworks) + "deny all;";

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

          extraConfig = cfg.trustedOnly;
          root = "/var/www/html";
        };

        "epelde.net" = {
          enableACME = true;
          forceSSL = true;

          # Points to the SRCF webserver.
          globalRedirect = "alex.epelde.net";
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
