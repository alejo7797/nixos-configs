{ lib, config, ... }:

let
  cfg = config.my.rtorrent;
  inherit (config.sops) secrets;
  inherit (config.networking) domain;
  inherit (config.users) groups;
in

{
  options.my.rtorrent.enable = lib.mkEnableOption "rTorrent";

  config = lib.mkIf cfg.enable {

    networking.nat = {
      enable = lib.mkDefault true;
      internalInterfaces = [ "ve-+" ];
    };

    containers.rtorrent = {
      autoStart = true;

      privateNetwork = true;
      hostAddress = "172.18.0.1";
      localAddress = "172.18.0.2";

      bindMounts = {
        # Access the VPN credentials.
        ${secrets."wireguard/airvpn/private-key".path} = { };
        ${secrets."wireguard/airvpn/preshared-key".path} = { };

        # Data download directories.
        "/data/hanekawa/downloads" = { };
        "/data/natsuhi/downloads" = { };
      };

      config = {

        users.groups.media = { inherit (groups.media) gid; };

        services = {
          rtorrent = {
            enable = true;
            group = "media";
          };

          flood = {
            enable = true;
            host = "172.18.0.2";
          };
        };

        networking = {

          # Allow access to the webUI.
          firewall.allowedTCPPorts = [ 3000 ];

          # Set up the AirVPN tunnel.
          wg-quick.interfaces."wg0" = {

            privateKeyFile = secrets."wireguard/airvpn/private-key".path;
            address = [ "10.134.211.44/32" "fd7d:76ee:e68f:a993:597:e1ef:fcfe:6e51/128" ];
            dns = [ "10.128.0.1" "fd7d:76ee:e68f:a993::1" ];

            peers = [
              {
                allowedIPs = [ "0.0.0.0/0" "::/0" ];
                endpoint = "199.189.27.125:1637";

                publicKey = "PyLCXAQT8KkM4T+dUsOQfn+Ub3pGxfGlxkIApuig+hk=";
                presharedKeyFile = secrets."wireguard/airvpn/preshared-key".path;
              }
            ];
          };

        };

        system.stateVersion = "25.05";
      };
    };

    services.nginx.virtualHosts = {

      "rutorrent.${domain}" = {

        my.trustedOnly = true;

        locations."/" = {
          proxyPass = "http://${config.containers.rtorrent.localAddress}:3000";
        };

      };
    };

    sops.secrets = {
      "wireguard/airvpn/preshared-key" = { };
      "wireguard/airvpn/private-key" = { };
    };
  };
}
