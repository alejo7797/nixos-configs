{
  # Did you read the comment?
  system.stateVersion = "24.11";

  imports = [
    ./filesystems.nix
    ./hardware-configuration.nix
  ];

  swapDevices = [ { device = "/var/swapfile"; size = 4096; } ];

  boot.kernelParams = [ "quiet" "nowatchdog" ];

  networking = {
    hostName = "patchouli";
  };

  sops.secrets = {
    "my-password" = { neededForUsers = true; };

    "acme/cloudflare" = { owner = "acme"; };

    "mailserver/alex" = { };
    "mailserver/ewan" = { };
    "mailserver/dmarc" = { };

    "nix-conf/gitlab-token" = { owner = "ewan"; };
    "syncthing/key.pem" = { owner = "syncthing"; };

    "wireguard/koakuma/private-key" = { };
    "wireguard/koakuma/preshared-key" = { };
  };

  myNixOS = {

    home-users."ewan" = {
      userConfig = ./home.nix;
      userSettings = {
        extraGroups = [ "media" "wheel" ];
      };
    };

    # Web server and reverse proxy.
    goaccess.enable = true;
    nginx.enable = true;

    # Simple NixOS mailserver.
    mailserver.enable = true;

    # Personal Nextcloud instance.
    nextcloud.enable = true;

    # Personal GitLab instance.
    gitlab.enable = true;

    # Friendly homepage.
    homepage.enable = true;

    # Plex media server & friends.
    mediaserver.enable = true;

    # Personal Minecraft server.
    minecraft.enable = true;

  };
}
