{ config, lib, ... }: {

  services.resolved = {

    extraConfig = lib.optionalString config.services.avahi.enable ''
      MulticastDNS=false  # Disable built-in mDNS service: using Avahi.
    '';

  };
}
