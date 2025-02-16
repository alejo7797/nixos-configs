{
  config,
  ...
}:

{
  # Did you read the comment?
  system.stateVersion = "24.11";

  imports = [ ./filesystems.nix ./hardware.nix ];

  swapDevices = [ { device = "/var/swapfile"; size = 4096; } ];

  boot = {
    kernelParams = [ "quiet" "nowatchdog" ];
    loader = { systemd-boot.enable = true; };
  };

  networking = {
    hostName = "patchouli";

    wireless = {
      enable = true;

      # Set up home WiFi authentication with wpa_supplicant.
      networks.xfinity_HUH_Res = { pskRaw = "ext:wifi-psk"; };
      secretsFile = config.sops.secrets."wpa-supplicant".path;
    };
  };

  time.timeZone = "America/New_York";

  sops.secrets = {
    "my-password" = { neededForUsers = true; };

    "syncthing/cert.pem" = { owner = "syncthing"; };
    "syncthing/key.pem" = { owner = "syncthing"; };

    "wireguard/koakuma/private-key" = { };
    "wireguard/koakuma/preshared-key" = { };

    "wpa-supplicant" = { };
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

  };
}
