{
  lib,
  config,
  ...
}:

let
  cfg = config.my.nvidia.prime;
in

{
  options.my.nvidia.prime.enable = lib.mkEnableOption "Nvidia PRIME render offload";

  config = lib.mkIf cfg.enable {

    hardware.nvidia = {

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

    };
  };
}
