{ pkgs, lib, config, ... }: {

  options.myNixOS.nvidia.enable = lib.mkEnableOption "nvidia";

  config = {
    
    # Install Nvidia kernel modules.
    hardware.graphics.enable = true;
    services.xserver.videoDrivers = [ "nvidia" ];

    # Don't use open source Nvidia drivers.
    hardware.nvidia.open = false;

  };
}
