{ modulesPath, ... }: {

  imports = [
    # Find out the contents over on the Nixpkgs repo.
    (modulesPath + "/installer/scan/not-detected.nix")
  ];

  boot = {
    initrd.availableKernelModules = [
      # Which kernel modules to load into the initial ramdisk image.
      "ahci" "nvme" "sd_mod" "usb_storage" "usbhid" "vmd" "xhci_pci"
    ];

    # Kernel modules to load at boot.
    kernelModules = [ "kvm-intel" ];
  };

  my.nvidia.enable = true;

  hardware = {
    # Thankfully available.
    bluetooth.enable = true;

    # Ensure we update CPU microcode.
    cpu.intel.updateMicrocode = true;
  };

  # Still not cool enough to use aarch64.
  nixpkgs.hostPlatform = "x86_64-linux";
}
