{
  lib,
  config,
  pkgs,
  ...
}:

let
  cfg = config.my.nvidia;
in

{
  options.my.nvidia.enable = lib.mkEnableOption "Nvidia";

  config = lib.mkIf cfg.enable {

    # Install Nvidia graphics drivers.
    services.xserver.videoDrivers = [ "nvidia" ];

    hardware.graphics = {
      # Additional driver packages.
      extraPackages = with pkgs; [ nvidia-vaapi-driver ];
    };

    hardware.nvidia = {
      # Use open source Nvidia drivers.
      open = true;

      # Enable kernel modesetting.
      modesetting.enable = true;

      # Access the Nvidia settings menu.
      nvidiaSettings = true;
    };
  };
}
