{
  boot.initrd = {
    # For systemd-cryptenroll support.
    # systemd.enable = true;

    luks.devices."root" = {
      device = "/dev/disk/by-uuid/3546cba5-44de-4a24-8d75-61912baebd31";
      crypttabExtraOpts = [ "fido2-device=auto" ];
    };
  };

  fileSystems = {
    "/" = {
      device = "/dev/disk/by-uuid/e94789a5-c903-43a6-b56e-0721d09e36c8";
      fsType = "ext4";
    };

    "/boot" = {
      device = "/dev/disk/by-uuid/3800-39F2";
      fsType = "vfat";
      options = [
        "fmask=0077"
        "dmask=0077"
      ];
    };
  };
}
