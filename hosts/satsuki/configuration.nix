{ pkgs, ... }:

{
  # Did you read the comment?
  system.stateVersion = "24.11";

  imports = [
    ./filesystems.nix
    ./hardware-configuration.nix
  ];

  swapDevices = [ { device = "/var/swapfile"; size = 16384; } ];

  boot = {
    loader.timeout = 0;
    kernelParams = [ "quiet" "nowatchdog" ];
  };

  hardware.bluetooth.enable = true;

  networking = {
    hostName = "satsuki";
    networkmanager.enable = true;
  };

  services = {
    printing.drivers = [ pkgs.hplip ];
    resolved.enable = true;
  };

  time.timeZone = "America/New_York";

  sops.secrets = {
    "my-password" = {
      neededForUsers = true;
    };

    "wireguard/koakuma/private-key" = { };
    "wireguard/koakuma/preshared-key" = { };

    "syncthing/cert.pem" = {
      owner = "ewan";
    };
    "syncthing/key.pem" = {
      owner = "ewan";
    };
  };

  myNixOS = {

    home-users."ewan" = {
      userConfig = ./home.nix;
    };

    dolphin.enable = true;
    hyprland.enable = true;
    jupyter.enable = true;
    laptop.enable = true;
    pam.auth.yubikey = true;
    sway.enable = true;

    nvidia = {
      enable = true;
      prime.enable = true;
    };

    tuigreet = {
      enable = true;
      autologin = {
        enable = true;
        user = "ewan";
      };
    };

  };

  programs = {
    gamemode.enable = true;
    thunderbird.enable = true;
    wireshark.enable = true;

    steam = {
      enable = true;
      protontricks.enable = true;
    };
  };

  environment.systemPackages = with pkgs; [

    # Actual programs.
    filezilla
    gimp inkscape
    joplin-desktop
    vesktop zotero

    # Newer features.
    unstable.lutris
    unstable.spotify

    dosbox-x
    easyrpg-player
    gamescope
    prismlauncher
    wine winetricks

    biber clang lldb
    mathematica-webdoc
    perl ruby sage

    # LaTeX.
    (texliveMedium.withPackages
    (ps: with ps; [ collection-langcyrillic ]))

  ];
}
