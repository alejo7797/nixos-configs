{ pkgs, lib, config, ... }: {

  options.myNixOS.nvidia.enable = lib.mkEnableOption "nvidia";

  config = {
    
    # Install Nvidia kernel modules.
    hardware.graphics.enable = true;
    services.xserver.videoDrivers = [ "nvidia" ];

    hardware.nvidia = {

      # Don't use open source Nvidia drivers.
      open = false;

      # Use 550 driver for RTX 4070 SUPER support.
      package = config.boot.kernelPackages.nvidiaPackages.beta;

    };
  };
}
