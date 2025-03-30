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

    firewall.my.no-vpn = [
      "en.wikipedia.org"
      "resolver1.opendns.com"
      "math.mit.edu"
    ];

    nameservers = [
      "9.9.9.9#dns.quad9.net" "149.112.112.112#dns.quad9.net"
      "[2620:fe::fe]#dns.quad9.net" "[2620:fe::9]#dns.quad9.net"
    ];

    networkmanager.dispatcherScripts = [
      {
        source = pkgs.writeShellScript "patchoulihq.cc-nta" ''

          ! [[ $2 == up ]] && exit 0

          case "$CONNECTION_ID" in

            Koakuma_VPN)
              nta="patchoulihq.cc" ;;

            xfinitywifi_HUH_Res)
              nta="patchoulihq.cc mail.epelde.net" ;;

            *) nta="" ;;
          esac

          resolvectl nta "$DEVICE_IFACE" "$nta"

        '';
      }
    ];
  };

  services = {
    resolved.enable = true;
    my.tzupdate.enable = true;

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
    yubikey._2fa = true;
  };

  myNixOS = {
    jupyter.enable = true;
  };

  environment.systemPackages = with pkgs; [

    # Math.
    gap
    geogebra
    khoca
    knotjob
    mathematica-webdoc
    sage
    snappy-math
    texliveFull
    zotero

    # Programming.
    clang
    nodejs
    bundix
    ruby

  ];
}
