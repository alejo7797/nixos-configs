{ config, lib, ... }:

let
  cfg = config.services.nginx;
in

{
  options.services.nginx = {

    my.trustedNetworks = lib.mkOption {

      type = with lib.types; listOf str;
      default = [ "127.0.0.0/8" "::1/128" ];

      description = ''
        Networks that are allowed access to virtual hosts
        which are protected by the `trustedOnly` option.
      '';

    };

    virtualHosts = lib.mkOption {

      type = with lib.types; attrsOf (submodule (

        { config, ... }: {

          options.my = {
            trustedOnly = lib.mkEnableOption "IP protection for this virtual host";
            increasedProxyTimeouts = lib.mkEnableOption "increased proxy timeouts";
          };

          config = {

            enableACME = lib.mkDefault true;
            forceSSL = lib.mkDefault true;

            extraConfig = ''
              ${
                lib.optionalString config.my.trustedOnly ''
                  ${
                    lib.concatStrings (
                      map (network: ''
                        allow ${network};
                      '') cfg.my.trustedNetworks
                    )
                  }
                  deny all;
                ''
              }
              ${
                lib.optionalString config.my.increasedProxyTimeouts ''
                  proxy_read_timeout 10m;
                  proxy_send_timeout 10m;
                ''
              }
            '';

          };

        }

      ));

    };

  };

  config = lib.mkIf cfg.enable {

    services.nginx = {

      clientMaxBodySize = "20M";

      commonHttpConfig = ''
        log_format main '$remote_addr - $remote_user [$time_local] '
                        '"$request" $status $body_bytes_sent '
                        '"$http_referer" "$http_user_agent"';
      '';

      # All-around good to set up.
      recommendedGzipSettings = true;
      recommendedOptimisation = true;
      recommendedTlsSettings = true;

      # Useful for my reverse proxies.
      recommendedProxySettings = true;

      virtualHosts = {

        "_" = {
          default = true;

          forceSSL = false;
          rejectSSL = true;

          extraConfig = ''
            return 444
          '';
        };

        ${config.networking.domain} = {

          my.trustedOnly = true;
          root = "/var/www/html";

        };

      };

    };

    networking.firewall = {
      allowedTCPPorts = [ 80 443 ];
    };

    sops.secrets = with config.users.users; {
      desec-token = { owner = acme.name; };
    };

  };
}
