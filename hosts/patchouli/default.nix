{
  config,
  ...
}:

let
  localIP = "100.105.183.8";
in

{
  # Did you read the comment?
  system.stateVersion = "24.11";

  imports = [ ./filesystems.nix ./hardware.nix ../../users/ewan ];

  swapDevices = [ { device = "/var/swapfile"; size = 4096; } ];

  boot = {
    kernelParams = [ "quiet" "nowatchdog" ];
    loader = { systemd-boot.enable = true; };
  };

  networking = {
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
      # File containing the wireguard interface's private key, as producted by `wg genkey`.
      privateKeyFile = config.sops.secrets."wireguard/koakuma/private-key".path;

      peers = [
        {
          allowedIPs = [ "0.0.0.0/0" "::/0" ];
          endpoint = "vpn.patchoulihq.cc:51820";

          publicKey = "b+GlQ2iouEiGH02pbMeqscMnTTaurDVE/EaH6Q2ud0E=";
          # File containing the preshared key for use with koakuma, as producted by `wg genpsk`.
          presharedKeyFile = config.sops.secrets."wireguard/koakuma/preshared-key".path;
        }
      ];
    };

    # For use by NixOS containers.
    nat.externalInterface = "wlo1";
  };

  time.timeZone = "America/New_York";

  sops.secrets = {
    "syncthing/cert.pem" = { owner = "syncthing"; };
    "syncthing/key.pem" = { owner = "syncthing"; };

    "wireguard/koakuma/private-key" = { };
    "wireguard/koakuma/preshared-key" = { };

    "wpa-supplicant" = { };
  };

  # TODO: refactor
  home-manager.sharedModules = [ ./home.nix ];

  myNixOS = {

    home-users."ewan" = {
      userConfig = ./home.nix;
      userSettings = {
        extraGroups = [
          "media" "wheel"
        ];
      };
    };

    nginx = {
      enable = true;

      trustedNetworks = [
        # The machine itself.
        "127.0.0.0/128" "::1/128"

        # My personal VPN subnets.
        "10.20.20.0/24" "fc00::/64"

        # The WiFi subnet.
        "100.105.183.0/26"
      ];
    };

    # Simple NixOS mailserver.
    mailserver.enable = true;

    # My personal Nextcloud.
    nextcloud.enable = true;

    # My personal GitLab.
    gitlab-runner.enable = true;
    gitlab.enable = true;

    # A friendly homepage.
    homepage.enable = true;

    # Plex media server & friends.
    mediaserver.enable = true;

    # My personal Minecraft server.
    minecraft.enable = true;

    # Web server analytics.
    goaccess.enable = true;

  };

  services = {

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

          # SSL certificate for serving DoT. We don't trust the local network that much.
          tls-service-pem = "${config.security.acme.certs."patchoulihq.cc".directory}/cert.pem";
          tls-service-key = "${config.security.acme.certs."patchoulihq.cc".directory}/key.pem";

          local-data = [
            # The local IP for patchouli.
            "patchouli.my-vpn. A ${localIP}"
            "patchoulihq.cc. A ${localIP}"

            # Make sure koakuma is still resolved.
            "koakuma.my-vpn. AAAA fc00::1"
            "koakuma.my-vpn. A 10.20.20.1"
          ];
        };

        forward-zone = [
          # Forward DNS queries to koakuma by default, through our VPN tunnel.
          { name = "."; forward-addr = [ "fc00::1" "10.20.20.1" ]; }
        ];
      };
    };

  };
}
