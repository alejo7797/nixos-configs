{ pkgs, lib, config, ... }: {

  options.myNixOS.nvidia.enable = lib.mkEnableOption "Nvidia";

  config = {

    hardware.graphics = {
      # Enable hardware-accelerated graphics.
      enable = true;

      # 32-bit support, e.g. for Wine.
      enable32Bit=true;

      # Additional graphics drivers.
      extraPackages = with pkgs; [ nvidia-vaapi-driver ];
    };

    # Use Nvidia drivers in X11.
    services.xserver.videoDrivers = [ "nvidia" ];

    hardware.nvidia = {
      # Use open source Nvidia drivers.
      open = true;

      # Enable kernel modesetting.
      modesetting.enable = true;
    };
  };
}
