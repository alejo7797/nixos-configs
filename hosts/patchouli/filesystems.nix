{
  fileSystems = {
    "/" = {
      device = "/dev/disk/by-uuid/";
      fsType = "ext4";
    };

    "/boot" = {
      device = "/dev/disk/by-uuid/";
      fsType = "vfat";
      options = [ "fmask=0077" "dmask=0077" ];
    };

    "/mnt/Hanekawa" = {
      device = "/dev/disk/by-uuid/c72d6264-55e3-4b1c-95cd-befa0fb59539";
      fsType = "ext4";
    };

    "/mnt/Natsuhi" = {
      device = "/dev/disk/by-uuid/6623CEF825160937";
      fsType = "ntfs";
      options = [ "uid=1000" "gid=1001" ];
    };
  };
}
