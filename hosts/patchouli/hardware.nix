{ config, lib, modulesPath, ... }:

let
  rtl8852bu = config.boot.kernelPackages.callPackage ./rtl8852bu.nix { };
in

{
  imports = [ (modulesPath + "/installer/scan/not-detected.nix") ];

  boot = {
    # Kernel modules in the initial ramdisk.
    initrd.availableKernelModules = [
      "xhci_pci" "ahci" "uas" "sdhci_pci"
    ];

    # Kernel modules to load at boot.
    kernelModules = [ "kvm-intel" ];

    blacklistedKernelModules = [ "ath9k" ];

    extraModulePackages = [ rtl8852bu ];

    extraModprobeConfig = ''
      options 8852bu rtw_switch_usb_mode=1
    '';
  };

  # Enables DHCP on each ethernet and wireless interface.
  networking.useDHCP = lib.mkDefault true;

  nixpkgs.hostPlatform = "x86_64-linux";
  hardware.cpu.intel.updateMicrocode = true;
}
