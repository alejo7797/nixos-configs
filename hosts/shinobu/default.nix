{ lib, pkgs, self, ... }:

{
  system.stateVersion = "24.11";

  imports = [
    # Set up my personal account.
    self.nixosModules.users.ewan

    # Other machine-specific config.
    ./filesystems.nix ./hardware.nix
  ];

  swapDevices = [{
    device = "/var/swapfile";
    size = 32768; # 32GiB.
  }];

  # Custom bootloader settings.
  boot.loader.systemd-boot = {

    windows."11" = {
      title = "Windows 11";
      efiDeviceHandle = "HD0b";
      sortKey = "a_windows";
    };

    extraInstallCommands = ''
      # Don't show auto-generated Windows entry in the menu.
      echo "auto-entries false" >>/boot/loader/loader.conf

      # Set Windows as the default boot entry. Booting into NixOS requires manual user intervention.
      ${lib.getExe pkgs.gnused} -i 's/default .*/default windows_11.conf/' /boot/loader/loader.conf
    '';

  };

  networking = {
    # Very good, it's me.
    hostName = "shinobu";

    # Actually a bit questionable.
    networkmanager.enable = true;

    nameservers = [
      # Some fallback DNS servers for systemd-resolved to use.
      "[2620:fe::fe]#dns.quad9.net" "[2620:fe::9]#dns.quad9.net"
      "9.9.9.9#dns.quad9.net" "149.112.112.112#dns.quad9.net"
    ];
  };

  services = {
    # Use systemd-resolved.
    resolved.enable = true;
  };

  # This desktop PC is not moving.
  time.timeZone = "Europe/Madrid";

  home-manager = {
    # Additional user configuration.
    users.ewan = import ./home.nix;
  };

  my = {
    # Main custom module.
    desktop.enable = true;

    # Set up desktop env.
    hyprland.enable = true;

    # Good package sets.
    gaming.enable = true;
    math.enable = true;

    # Lax YubiKey setup.
    yubikey.sudo = true;
  };
}
