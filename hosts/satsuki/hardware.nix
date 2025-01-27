{ lib, modulesPath, ... }: {

  imports = [ (modulesPath + "/installer/scan/not-detected.nix") ];

  boot = {
    # Kernel modules in the initial ramdisk.
    initrd.availableKernelModules = [
      "vmd" "nvme" "usbhid" "rtsx_pci_sdmmc"
    ];

    # Kernel modules to load at boot.
    kernelModules = [ "kvm-intel" ];
  };

  # Enables DHCP on each ethernet and wireless interface.
  networking.useDHCP = lib.mkDefault true;

  nixpkgs.hostPlatform = "x86_64-linux";
  hardware.cpu.intel.updateMicrocode = true;

}
