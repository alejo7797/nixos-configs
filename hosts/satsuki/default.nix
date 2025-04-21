{ lib, inputs, pkgs, self, ... }:

{
  system.stateVersion = "24.11";

  imports = [
    # Set up my personal account.
    self.nixosModules.users.ewan

    # Import and use Lanzabote's NixOS module.
    inputs.lanzaboote.nixosModules.lanzaboote

    # Other machine-specific config.
    ./filesystems.nix ./hardware.nix
  ];

  swapDevices = [{
    device = "/var/swapfile";
    size = 16384; # 16GiB.
  }];

  boot = {
    lanzaboote = {
      enable = true; # Secure boot.
      pkiBundle = "/var/lib/sbctl";
    };

    # Lanzaboote requires disabling systemd-boot.
    loader.systemd-boot.enable = lib.mkForce false;

    # Don't show menu.
    loader.timeout = 0;
  };

  networking = {
    # Very good, it's me.
    hostName = "satsuki";

    # A good choice for a laptop.
    networkmanager.enable = true;

    firewall.my.no-vpn = [
      "en.wikipedia.org" # Edit Wikipedia.
      "resolver1.opendns.com" # Accurate IP.
      "api.beacondb.net" # Geo-location.
    ];

    nameservers = [
      # Some fallback DNS servers for systemd-resolved to use.
      "[2620:fe::fe]#dns.quad9.net" "[2620:fe::9]#dns.quad9.net"
      "9.9.9.9#dns.quad9.net" "149.112.112.112#dns.quad9.net"
    ];
  };

  services = {
    getty = {
      autologinUser = "ewan";
      autologinOnce = true;
    };

    # Use systemd-resolved.
    resolved.enable = true;

    # Updates using public IP.
    my.tzupdate.enable = true;

    udev = {
      extraRules = ''
        # Prevent the Logitech mouse receiver from waking the system up from suspend.
        ACTION=="add|change", SUBSYSTEM=="usb", DRIVERS=="usb", ATTRS{idVendor}=="046d", \
        ATTRS{idProduct}=="c547", ATTR{power/wakeup}="disabled"
      '';

      packages = [
        (pkgs.writeTextDir "etc/udev/rules.d/71-usb.rules" ''
          # Give regular users full access to USB devices.
          SUBSYSTEM=="usb", MODE="0660", TAG+="uaccess"
        '')
      ];
    };
  };

  home-manager = {
    # Additional user configuration.
    users.ewan = import ./home.nix;
  };

  sops.secrets.u2f-mappings = {
    # YubiKey pam-u2f module secrets.
    group = "users"; mode = "0440";
  };

  my = {
    # Main custom module.
    laptop.enable = true;

    # Set up desktop env.
    hyprland.enable = true;

    # Good package sets.
    gaming.enable = true;
    math.enable = true;

    # Extra 2FA security.
    yubikey._2fa = true;
  };
}
