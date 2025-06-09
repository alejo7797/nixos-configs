{ config, inputs, lib, pkgs, self, ... }: {

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
    hostName = "satsuki";

    my.airvpn = {
      enable = true;
      address = "10.131.183.183";
      address6 = "fd7d:76ee:e68f:a993:9401:8cf2:f255:ed7d";
      servers.AirVPN_Spain.autoconnect = true;
    };

    networkmanager = {
      enable = true;

      logLevel = "INFO";

      ensureProfiles.environmentFiles = [ config.sops.secrets.nm-secrets.path ];

      dispatcherScripts = [
        {
          source = pkgs.writeShellScript "nta-script" ''

            ! [[ $2 == up ]] && exit 0

            case "$CONNECTION_ID" in

              Koakuma_VPN|xfinitywifi_HUH_Res)
                nta="patchoulihq.cc" ;;

              *) exit 0 ;;

            esac

            # Sets DNSSEC negative trust anchors.
            resolvectl nta "$DEVICE_IFACE" "$nta"

          '';
        }
      ];
    };

    firewall.my.no-vpn = [
      "en.wikipedia.org" # Edit Wikipedia.
      "resolver1.opendns.com" # Accurate IP.
      "api.beacondb.net" # Geo-location.
    ];

    nameservers = [
      # Fallback DNS servers for systemd-resolved to use.
      "9.9.9.9#dns.quad9.net" "149.112.112.112#dns.quad9.net"
      "2620:fe::fe#dns.quad9.net" "2620:fe::9#dns.quad9.net"
    ];
  };

  services = {
    getty = {
      autologinUser = "ewan";
      autologinOnce = true;
    };

    # Use systemd-resolved.
    resolved.enable = true;

    # Drivers for department printer.
    printing.drivers = [ pkgs.hplip ];

    # Updates using public IP.
    my.tzupdate.enable = true;

    udev = {
      extraRules = ''
        # Prevent the Logitech mouse receiver from waking the system up from suspend.
        ACTION=="add|change", SUBSYSTEM=="usb", DRIVERS=="usb", ATTRS{idVendor}=="046d", \
        ATTRS{idProduct}=="c547", ATTR{power/wakeup}="disabled"
      '';

      packages = [
        (pkgs.writeTextDir "etc/udev/rules.d/71.rules" ''
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

  sops.secrets = {

    nm-secrets = { };

    u2f-mappings = {
      # YubiKey pam-u2f module secrets.
      group = "users"; mode = "0440";
    };

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
