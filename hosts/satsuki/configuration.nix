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
    lanzaboote = {
      enable = true;
      pkiBundle = "/var/lib/sbctl";
    };
    loader.timeout = 0;
    kernelParams = [ "quiet" "nowatchdog" ];
  };

  hardware.bluetooth.enable = true;

  networking = {
    hostName = "satsuki";
    networkmanager.enable = true;

    firewall.extraCommands = ''
      iptables -t mangle -A OUTPUT -d 208.67.222.222 -p udp --dport 53 -j MARK --set-mark 0xcbca
      iptables -t nat -A POSTROUTING -d 208.67.222.222 -p udp --dport 53 -j MASQUERADE
    '';
  };

  services = {
    printing.drivers = [ pkgs.hplip ];
    resolved.enable = true;
  };

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
    tzupdate.enable = true;

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
    digikam geogebra
    filezilla gimp
    inkscape krita
    joplin-desktop
    vesktop zotero

    # Newer versions.
    unstable.lutris
    unstable.spotify

    # Games and all that.
    dosbox-x easyrpg-player
    gamescope prismlauncher
    retroarch winetricks
    wineWowPackages.stable

    # Programming.
    clang jdk23 nodejs
    bundix bundler ruby
    mathematica-webdoc
    biber texliveFull

  ];
}
