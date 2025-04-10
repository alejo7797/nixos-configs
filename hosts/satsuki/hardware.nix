{ lib, modulesPath, ... }: {

  imports = [ (modulesPath + "/installer/scan/not-detected.nix") ];

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

  my.intel-graphics.enable = true;

  hardware = {
    bluetooth.enable = true;
    cpu.intel.updateMicrocode = true;

    # Necessary fix at the moment for RTD3 power management.
    nvidia = { open = lib.mkForce false; gsp.enable = false; };
  };

  nixpkgs.hostPlatform = "x86_64-linux";
}
