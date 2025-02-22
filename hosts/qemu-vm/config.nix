{
  lib,
  config,
  ...
}:

let
  localIP = "100.105.183.8";
in

{
  # Did you read the comment?
  system.stateVersion = "24.11";

  # QEMU guest settings.
  virtualisation.qemu.options = [ "-device virtio-vga" ];

  # Set the system architecure.
  nixpkgs.hostPlatform.system = "x86_64-linux";

  boot = {
    kernelParams = [ "quiet" "nowatchdog" ];
    loader = { systemd-boot.enable = true; };
  };

  networking = {
    hostName = "nixos-vm";

    firewall = {
      # Listen to DNS queries.
      allowedTCPPorts = [ 853 ];
    };

    wireless = {
      # We use WiFi.
      enable = true;

      # Set up WiFi authentication with wpa_supplicant.
      networks.xfinity_HUH_Res = { pskRaw = "ext:wifi-psk"; };
      secretsFile = config.sops.secrets."wpa-supplicant".path;
    };
  };

  systemd.network = {
    enable = true;

    netdevs."10-wg0" = { };
    networks."10-wg0" = { };
  };

  time.timeZone = "America/New_York";

  sops = {
    # Override secrets file for VM testing purposes.
    defaultSopsFile = lib.mkForce ../../secrets/patchouli.yaml;

    secrets = {
      "my-password" = { neededForUsers = true; };

      "syncthing/cert.pem" = { owner = "syncthing"; };
      "syncthing/key.pem" = { owner = "syncthing"; };

      "wireguard/koakuma/private-key" = { owner = "systemd-network"; };
      "wireguard/koakuma/preshared-key" = { owner = "systemd-network"; };

      "wpa-supplicant" = { };
    };
  };

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
        "10.20.20.0/24" "fd00::/8"

        # The WiFi subnet.
        "100.105.183.0/26"
      ];
    };

    # Simple NixOS mailserver.
    mailserver.enable = true;

    # My personal Nextcloud.
    nextcloud.enable = true;

    # My personal GitLab.
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
          tls-service-pem = "${config.security.acme.certs."patchoulihq.cc".directory}/fullchain.pem";
          tls-service-key = "${config.security.acme.certs."patchoulihq.cc".directory}/key.pem";

          local-data = [
            # The local IP for patchouli.
            "patchouli.my-vpn. A ${localIP}"
            "patchoulihq.cc. A ${localIP}"

            # Make sure koakuma is still resolved.
            "koakuma.my-vpn. AAAA fdaa:d7cf:c47f:8b79::1"
            "koakuma.my-vpn. A 10.20.20.1"
          ];
        };

        forward-zone = [
          # Forward DNS queries to koakuma by default, through our VPN tunnel.
          { name = "."; forward-addr = [ "fdaa:d7cf:c47f:8b79::1" "10.20.20.1" ]; }
        ];
      };
    };

  };
}
