{ pkgs, lib, config, ... }: {

  options.myNixOS.nvidia.enable = lib.mkEnableOption "nvidia";

  config = {
    
    hardware.graphics.enable = true;
    services.xserver.videoDrivers = [ "nvidia" ];
    hardware.nvidia.open = true;

  };
}
