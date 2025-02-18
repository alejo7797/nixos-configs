{
  lib,
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

      bindMounts = { };

      config = {

        services = {

          rtorrent = {

          };

          rutorrent = {

          };

        };

        networking = {

          # Allow access to the webUI.
          firewall.allowedTCPPorts = [ 80 ];

          # Set up the AirVPN tunnel.
          wg-quick.interfaces."wg0" = {

          };

        };

        system.stateVersion = "24.11";
      };
    };

    services = {
      nginx.virtualhosts."rutorrent.patchoulihq.cc" = {

        # Use our wildcard SSL certificate.
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
