{ modulesPath, ... }: {

  imports = [ (modulesPath + "/installer/scan/not-detected.nix") ];

  boot = {
    initrd.availableKernelModules = [
      # Kernel modules in the initial ramdisk.
      "vmd" "nvme" "usbhid" "rtsx_pci_sdmmc"
    ];

    # Kernel modules to load at boot.
    kernelModules = [ "kvm-intel" ];

    extraModprobeConfig = ''
      # Needed for the dGPU to turn off properly.
      options nvidia "NVreg_EnableGpuFirmware=0"
    '';
  };

  # Use the Nvidia MX450 dGPU in PRIME render offload mode.
  myNixOS.nvidia = { enable = true; prime.enable = true; };

  hardware.cpu.intel.updateMicrocode = true;
  nixpkgs.hostPlatform = "x86_64-linux";
}
