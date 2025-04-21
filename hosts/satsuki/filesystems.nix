{
  boot.initrd = {
    # systemd-cryptenroll.
    systemd.enable = true;

    luks.devices."root" = {
      device = "/dev/disk/by-uuid/3546cba5-44de-4a24-8d75-61912baebd31";
      crypttabExtraOpts = [ "fido2-device=auto" ]; # Yubikey-protected.
    };
  };

  fileSystems = {
    "/" = {
      label = "NixOS";
      fsType = "ext4";
    };

    "/boot" = {
      # The (unencrypted) EFI system partition.
      device = "/dev/nvme0n1p1"; fsType = "vfat";
      options = [ "fmask=0077" "dmask=0077" ];
    };
  };
}
