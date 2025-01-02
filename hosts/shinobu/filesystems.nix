{ pkgs, lib, config, ... }: {

  fileSystems = {

    "/" = {
      device = "/dev/disk/by-label/NixOS";
      fsType = "ext4";
    };

    "/boot" = {
      device = "/dev/disk/by-uuid/9978-8347";
      fsType = "vfat";
      options = [ "fmask=0077" "dmask=0077" ];
    };

    "/mnt/windows" = {
      device = "/dev/disk/by-label/Windows";
      fsType = "ntfs";
    };

    "/mnt/vault" = {
      device = "/dev/disk/by-label/Vault";
      fsType = "ntfs";
    };
  };
}
