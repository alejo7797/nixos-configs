{
  fileSystems = {

    "/" = {
      device = "/dev/disk/by-uuid/818b5345-df64-4f53-9e0b-2c9e50843c90";
      fsType = "ext4";
    };

    "/boot" = {
      device = "/dev/disk/by-uuid/9978-8347";
      fsType = "vfat";
      options = [ "fmask=0077" "dmask=0077" ];
    };

    "/mnt/windows" = {
      device = "/dev/disk/by-uuid/";
      fsType = "ntfs";
    };

    "/mnt/vault" = {
      device = "/dev/disk/by-uuid/";
      fsType = "ntfs";
    };

  };
}
