{ pkgs, lib, config, ... }: {

  options.myNixOS.nvidia.enable = lib.mkEnableOption "nvidia";

  config = {
    
    # Install Nvidia kernel modules.
    hardware.graphics.enable = true;
    services.xserver.videoDrivers = [ "nvidia" ];

    hardware.nvidia = {

      # Use open source Nvidia drivers.
      open = true;
      
      # Troubleshooting suspend issues.
      nvidiaPersistenced = true;

    };
  };
}
