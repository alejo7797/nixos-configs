{ config, lib, self, ... }:

let
  localIP = "100.105.183.8";
in

{
  system.stateVersion = "25.05";

  imports = [
    # Set up my personal account.
    self.nixosModules.users.ewan

    # Other machine-specific config.
    ./filesystems.nix ./hardware.nix
  ];

  swapDevices = [{
    device = "/var/swapfile";
    size = 4096; # 4GiB.
  }];

  networking = {
    # Personal playground.
    domain = "patchoulihq.cc";
    hostName = "patchouli";

    firewall = {
      # Listen to DNS queries.
      allowedTCPPorts = [ 853 ];
    };

    wireless = {
      enable = true;

      # Set up WiFi authentication with wpa_supplicant.
      networks.xfinity_HUH_Res = { pskRaw = "ext:wifi-psk"; };
      secretsFile = config.sops.secrets."wpa-supplicant".path;
    };

    # My own wireguard tunnel.
    wg-quick.interfaces."wg0" = {

      address = [ "10.20.20.2/32" "fc00::2/128" ];
      # File containing the wireguard interface's private key, c.f. `wg genkey`.
      privateKeyFile = config.sops.secrets."wireguard/koakuma/private-key".path;

      peers = [
        {
          allowedIPs = [ "0.0.0.0/0" "::/0" ];
          endpoint = "vpn.patchoulihq.cc:51820";

          publicKey = "b+GlQ2iouEiGH02pbMeqscMnTTaurDVE/EaH6Q2ud0E=";
          # File containing the preshared key for use with the server, c.f. `wg genpsk`.
          presharedKeyFile = config.sops.secrets."wireguard/koakuma/preshared-key".path;
        }
      ];
    };

    # For use by NixOS containers.
    nat.externalInterface = "wlo1";
  };

  time.timeZone = "America/New_York";

  sops.secrets = with config.users.users;{

    "acme/desec" = { owner = acme.name; };

    "syncthing/cert.pem" = { owner = syncthing.name; };
    "syncthing/key.pem" = { owner = syncthing.name; };

    "wireguard/koakuma/preshared-key" = { };
    "wireguard/koakuma/private-key" = { };

    "wpa-supplicant" = { };

  };


  home-manager = {
    # Additional user configuration.
    users.ewan = import ./home.nix;
  };

  my = {
    media-server.enable = true;
  };

  mailserver.enable = true;

  myNixOS = {

    # My personal GitLab.
    gitlab-runner.enable = true;

    # A friendly homepage.
    homepage.enable = true;

    # My personal Minecraft server.
    minecraft.enable = true;

  };

  services = {

    gitlab.enable = true;
    nextcloud.enable = true;

    nginx = {
      my.trustedNetworks = lib.mkOptionDefault [
        "10.20.20.0/24" "fc00::/64" # VPN subnet.
        "100.105.183.0/26" # Local WiFi network.
      ];
    };

    syncthing = {
      enable = true;

      cert = config.sops.secrets."syncthing/cert.pem".path;
      key = config.sops.secrets."syncthing/key.pem".path;

      settings = {

      };
    };

    unbound = {
      enable = true;

      # Add to /etc/resolv.conf.
      resolveLocalQueries = true;

      settings = {
        server = {
          # Listen on localhost and the wireless interface.
          interface = [ "::1" "127.0.0.1" "${localIP}@853" ];

          # SSL certificate for serving DoT. We don't trust the local WiFi network that much.
          tls-service-pem = "${config.security.acme.certs."patchoulihq.cc".directory}/cert.pem";
          tls-service-key = "${config.security.acme.certs."patchoulihq.cc".directory}/key.pem";

          local-data = [
            # Send back the local IP for patchouli.
            "patchouli.patchoulihq.cc. A ${localIP}"

            # Make sure koakuma is still resolved.
            "koakuma.patchoulihq.cc. AAAA fc00::1"
            "koakuma.patchoulihq.cc. A 10.20.20.1"
          ];
        };

        forward-zone = [
          # Forward DNS queries to koakuma, through our VPN tunnel.
          { name = "."; forward-addr = [ "fc00::1" "10.20.20.1" ]; }
        ];
      };
    };

  };
}
