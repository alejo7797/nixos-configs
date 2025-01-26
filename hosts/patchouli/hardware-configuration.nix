{ config, lib, modulesPath, ... }:

let
  rtl8852bu = config.boot.kernelPackages.callPackage ./rtl8852bu.nix { };
in 

{
  imports = [ (modulesPath + "/installer/scan/not-detected.nix") ];

  boot = {
    initrd.availableKernelModules = [ "xhci_pci" "ahci" "uas" "sdhci_pci" ];
    initrd.kernelModules = [ ];
    kernelModules = [ "kvm-intel" ];
    extraModulePackages = [ rtl8852bu ];
  };

  # Enables DHCP on each ethernet and wireless interface.
  networking.useDHCP = lib.mkDefault true;

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}
