{ pkgs, ... }:

{
  # Did you read the comment?
  system.stateVersion = "24.11";

  imports = [ ./filesystems.nix ./hardware.nix ];

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
      # Route traffic to resolver1.opendns.com outside the VPN tunnel.
      iptables -t mangle -A OUTPUT -d 208.67.222.222 -p udp --dport 53 -j MARK --set-mark 0xcbca
      iptables -t nat -A POSTROUTING -d 208.67.222.222 -p udp --dport 53 -j MASQUERADE
    '';
  };

  services = {
    resolved.enable = true;
    printing.drivers = [ pkgs.hplip ];

    udev.extraRules = ''
      # Prevent wakeups from the Logitech USB receiver, which is known to misbehave.
      ACTION=="add|change", SUBSYSTEM=="usb", DRIVERS=="usb", ATTRS{idVendor}=="046d", ATTRS{idProduct}=="c547", ATTR{power/wakeup}="disabled"
    '';
  };

  sops.secrets = {
    "my-password" = { neededForUsers = true; };

    "syncthing/cert.pem" = { owner = "ewan"; };
    "syncthing/key.pem" = { owner = "ewan"; };

    "u2f-mappings" = { group = "users"; mode = "0440"; };

    "wireguard/koakuma/private-key" = { };
    "wireguard/koakuma/preshared-key" = { };
  };

  myNixOS = {

    home-users."ewan" = {
      userConfig = ./home.nix;
      userSettings = {
        extraGroups = [ "wheel" ];
      };
    };

    dolphin.enable = true;
    hyprland.enable = true;
    jupyter.enable = true;
    laptop.enable = true;
    pam.auth.yubikey = true;
    retroarch.enable = true;
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
    digikam filezilla geogebra
    inkscape joplin-desktop krita
    gimp spotify vesktop zotero

    # Games and all that.
    bolt-launcher dosbox-x
    easyrpg-player mangohud
    lutris prismlauncher
    winetricks gamescope
    wineWowPackages.stable

    # Programming.
    clang jdk23 nodejs
    bundix bundler gap
    mathematica-webdoc
    ruby sage SnapPy
    biber texliveFull

  ];
}
