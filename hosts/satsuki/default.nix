{ inputs, pkgs, ... }:

{
  # Did you read the comment?
  system.stateVersion = "24.11";

  imports = [
    inputs.lanzaboote.nixosModules.lanzaboote
    ./filesystems.nix ./hardware.nix

    # TODO: figure this out
    ../../users/ewan
  ];

  swapDevices = [{
    device = "/var/swapfile";
    size = 16384; # 16GiB.
  }];

  boot = {
    kernelParams = [
      "quiet" "nowatchdog"
    ];

    lanzaboote = {
      enable = true; # Secure boot.
      pkiBundle = "/var/lib/sbctl";
    };

    loader.timeout = 0;
  };


  networking = {
    hostName = "satsuki";
    networkmanager.enable = true;

    firewall.my.no-vpn = [
      "en.wikipedia.org"
      "resolver1.opendns.com"
      "api.beacondb.net"
      "math.mit.edu"
    ];

    nameservers = [
      "9.9.9.9#dns.quad9.net"
      "149.112.112.112#dns.quad9.net"
      "[2620:fe::fe]#dns.quad9.net"
      "[2620:fe::9]#dns.quad9.net"
    ];
  };

  services = {
    getty = {
      autologinUser = "ewan";
      autologinOnce = true;
    };

    resolved.enable = true;
    my.tzupdate.enable = true;

    udev = {
      extraRules = ''
        # Prevent the Logitech mouse receiver from waking the system up from suspend.
        ACTION=="add|change", SUBSYSTEM=="usb", DRIVERS=="usb", ATTRS{idVendor}=="046d", \
        ATTRS{idProduct}=="c547", ATTR{power/wakeup}="disabled"
      '';

      packages = [
        (pkgs.writeTextDir "etc/udev/rules.d/71-usb-device.rules" ''
          # Give regular users full access to USB devices.
          SUBSYSTEM=="usb", MODE="0660", TAG+="uaccess"
        '')
      ];
    };
  };

  home-manager = {
    users.ewan = import ./home.nix;
  };

  sops.secrets = {
    u2f-mappings = {
      # YubiKey pam-u2f module secrets.
      group = "users"; mode = "0440";
    };
  };

  my = {
    gaming.enable = true;
    hyprland.enable = true;
    laptop.enable = true;
    math.enable = true;
    yubikey._2fa = true;
  };
}
