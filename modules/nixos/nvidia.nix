{ pkgs, lib, config, ... }: {

  options.myNixOS.nvidia.enable = lib.mkEnableOption "Nvidia";

  config = {

    # Install Nvidia kernel modules.
    hardware.graphics.enable = true;
    services.xserver.videoDrivers = [ "nvidia" ];

    hardware.nvidia = {
      # Use open source Nvidia drivers.
      open = true;
      # Enable kernel modesetting.
      modesetting.enable = true;
    };

  };
}
