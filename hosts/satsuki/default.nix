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

    # TODO: make this into a separate module?

    firewall.extraCommands = ''
      iptables -t mangle -D OUTPUT -j my-filter 2>/dev/null || true
      iptables -t nat -D POSTROUTING -j my-reroute 2>/dev/null || true

      for chain in my-filter my-reroute; do
        iptables -t mangle -F "$chain" 2>/dev/null || true
        iptables -t mangle -X "$chain" 2>/dev/null || true
      done

      iptables -t nat -F my-reroute 2>/dev/null || true
      iptables -t nat -X my-reroute 2>/dev/null || true

      iptables -t mangle -N my-filter
      iptables -t mangle -N my-reroute
      iptables -t nat -N my-reroute

      iptables -t mangle -A my-filter -d 208.67.222.222 -p udp --dport 53 -j my-reroute
      iptables -t mangle -A my-filter -d 18.1.0.0/16 -p tcp --dport 443 -j my-reroute

      iptables -t mangle -A my-reroute -j MARK --set-mark 0xcbca

      iptables -t nat -A my-reroute -m mark --mark 0xcbca -j MASQUERADE

      iptables -t nat -A POSTROUTING -j my-reroute
      iptables -t mangle -A OUTPUT -j my-filter
    '';

    nameservers = [
      "9.9.9.9#dns.quad9.net" "149.112.112.112#dns.quad9.net"
      "[2620:fe::fe]#dns.quad9.net" "[2620:fe::9]#dns.quad9.net"
    ];
  };

  services = {
    resolved.enable = true;

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
    tzupdate.enable = true;
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
