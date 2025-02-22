{
  lib,
  inputs,
  config,
  ...
}:

let
  cfg = config.myNixOS.rutorrent;
in

{
  options.myNixOS.rutorrent.enable = lib.mkEnableOption "rTorrent";

  config = lib.mkIf cfg.enable {

    networking.nat = {
      enable = lib.mkDefault true;
      internalInterfaces = [ "ve-rtorrent" ];
    };

    containers.rtorrent = {
      autoStart = true;

      privateNetwork = true;
      hostAddress = "172.18.0.1";
      localAddress = "172.18.0.2";

      bindMounts = {
        # For sops-nix to decrypt the VPN secrets.
        "/etc/ssh/ssh_host_ed25519_key".isReadOnly = true;

        # Data download directories.
        "/data/hanekawa/downloads" = { };
        "/data/natsuhi/downloads" = { };
        "/data/natsuhi/media/Music" = { };
      };

      config = { config, ...}: {

        imports = [ inputs.sops-nix.nixosModules.sops ];

        # Matches the GID in the host.
        users.groups.media = { gid = 1001; };

        services = {
          rtorrent = {
            enable = true;
            group = "media";
          };

          rutorrent = {
            enable = true;
            nginx.enable = true;

            # For use by the Nginx virtual host.
            hostName = "rutorrent.patchoulihq.cc";
          };
        };

        networking = {

          # Allow access to the webUI.
          firewall.allowedTCPPorts = [ 80 ];

          # Set up the AirVPN tunnel.
          wg-quick.interfaces."wg0" = {

            privateKeyFile = config.sops.secrets."wireguard/airvpn/private-key".path;
            address = [ "10.134.211.44/32" "fd7d:76ee:e68f:a993:597:e1ef:fcfe:6e51/128" ];
            dns = [ "10.128.0.1" "fd7d:76ee:e68f:a993::1" ];

            peers = [
              {
                allowedIPs = [ "0.0.0.0/0" "::/0" ];
                endpoint = "199.189.27.125:1637";

                publicKey = "PyLCXAQT8KkM4T+dUsOQfn+Ub3pGxfGlxkIApuig+hk=";
                presharedKeyFile = config.sops.secrets."wireguard/airvpn/preshared-key".path;
              }
            ];
          };

        };

        sops = {
          defaultSopsFile = ../../../../secrets/airvpn.yaml;
          age.sshKeyPaths = [ "/etc/ssh/ssh_host_ed25519_key" ];

          secrets = {
            "wireguard/airvpn/private-key" = { };
            "wireguard/airvpn/preshared-key" = { };
          };
        };

        system.stateVersion = "24.11";
      };
    };

    services = {
      nginx.virtualHosts."rutorrent.patchoulihq.cc" = {

        # Use our existing wildcard SSL certificate.
        useACMEHost = "patchoulihq.cc"; forceSSL = true;

        # Restrict access only to trusted networks.
        extraConfig = config.myNixOS.nginx.trustedOnly;

        locations."/" = {
          # Proxy to ruTorrent on its container.
          proxyPass = "http://172.18.0.2:80";
        };
      };
    };
  };
}
