{ config, lib, ... }:

let
  cfg = config.my.nvidia;
in

{
  options.my.nvidia = {
    enable = lib.mkEnableOption "Nvidia";
    prime.enable = lib.mkEnableOption "Nvidia PRIME render offload";
  };


  config = lib.mkIf cfg.enable {

    # Install Nvidia graphics drivers.
    services.xserver.videoDrivers = [ "nvidia" ];

    hardware.nvidia = lib.mkMerge [

      {
        # Use open source Nvidia drivers.
        open = true;

        # Enable kernel modesetting.
        modesetting.enable = true;

        # Access the Nvidia settings menu.
        nvidiaSettings = true;
      }

      (lib.mkIf cfg.prime.enable {

        powerManagement = {
          enable = true;
          finegrained = true;
        };

        prime = {
          intelBusId = "PCI:0:2:0";
          nvidiaBusId = "PCI:1:0:0";

          offload = {
            enable = true;
            enableOffloadCmd = true;
          };
        };
      })

    ];
  };
}
