{ inputs, pkgs, ... }:

{
  # Did you read the comment?
  system.stateVersion = "24.11";

  imports = [
    inputs.lanzaboote.nixosModules.lanzaboote
    ./filesystems.nix ./hardware.nix

    ../../users/ewan
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
      # Route traffic to resolver1.opendns.com outside of the VPN tunnel.
      iptables -t mangle -A OUTPUT -d 208.67.222.222 -p udp --dport 53 -j MARK --set-mark 0xcbca
      iptables -t nat -A POSTROUTING -d 208.67.222.222 -p udp --dport 53 -j MASQUERADE
    '';
  };

  services = {
    # Domain Name Resolution.
    resolved.enable = true;

    # Install drivers for HP printers.
    printing.drivers = [ pkgs.hplip ];

    udev.extraRules = ''
      # Prevent the Logitech USB mouse receiver from waking the system up from suspend. It has been known to cause issues for us in the past.
      ACTION=="add|change", SUBSYSTEM=="usb", DRIVERS=="usb", ATTRS{idVendor}=="046d", ATTRS{idProduct}=="c547", ATTR{power/wakeup}="disabled"
    '';

    getty = {
      autologinUser = "ewan";
      autologinOnce = true;
    };
  };

  home-manager = {
    # TODO: refactor
    # split into *@satsuki stuff
    # and ewan@satsuki stuff
    sharedModules = [ ./home.nix ];
  };

  sops.secrets = {
    u2f-mappings = {
      # YubiKey pam-u2f module secrets.
      group = "users"; mode = "0440";
    };
  };

  my = {
    laptop.enable = true;
    yubikey._2fa = true;
  };

  myNixOS = {

    dolphin.enable = true;
    hyprland.enable = true;
    jupyter.enable = true;
    retroarch.enable = true;
    tzupdate.enable = true;

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
    anki audacity castero
    digikam gimp filezilla
    geogebra inkscape krita
    joplin-desktop musescore
    plex-desktop spotify
    tellico vesktop zotero

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
    knotjob snappy-math
    biber texliveFull
    sage khoca ruby

  ];
}
