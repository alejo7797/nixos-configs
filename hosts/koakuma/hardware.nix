{
  boot.initrd.availableKernelModules = [
    "xhci_pci" "ahci" "virtio_pci" "virtio_scsi" "sd_mod" "sr_mod" "ext4"
  ];

  fileSystems = {

    "/" = {
      device = "/dev/disk/by-label/nixos"; fsType = "ext4";
    };

    "/boot" = {
      device = "/dev/disk/by-label/boot"; fsType = "ext4";
    };

  };

  nixpkgs.hostPlatform = "x86_64-linux";
}
