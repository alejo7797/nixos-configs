{ lib, modulesPath, ... }: {

  imports = [
    # Find out the contents over on the Nixpkgs repo.
    (modulesPath + "/installer/scan/not-detected.nix")
  ];

  boot = {
    initrd.availableKernelModules = [
      # Kernel modules in the initial ramdisk.
      "vmd" "nvme" "usbhid" "rtsx_pci_sdmmc"
    ];

    # Kernel modules to load at boot.
    kernelModules = [ "kvm-intel" ];
  };

  # Use the Nvidia dGPU in PRIME render offload mode.
  my.nvidia = { enable = true; prime.enable = true; };

  hardware = {
    # Thankfully available.
    bluetooth.enable = true;

    # Ensure we update CPU microcode.
    cpu.intel.updateMicrocode = true;

    # Load extra Intel GPU drivers.
    my.intel-graphics.enable = true;

    # Necessary fix at the moment for working power management.
    nvidia = { open = lib.mkForce false; gsp.enable = false; };
  };

  # Still not cool enough to use aarch64.
  nixpkgs.hostPlatform = "x86_64-linux";
}
