{ pkgs, lib, config, ... }: {

  options.myNixOS.nvidia.enable = lib.mkEnableOption "Nvidia";

  config = lib.mkIf config.myNixOS.nvidia.enable {

    hardware.graphics = {
      # Enable hardware-accelerated graphics.
      enable = true;

      # 32-bit support, e.g. for Wine.
      enable32Bit=true;

      # Additional graphics drivers.
      extraPackages = with pkgs; [ nvidia-vaapi-driver ];
    };

    # Early KMS start.
    boot.kernelModules = [
      "nvidia"
      "nvidia_modeset"
      "nvidia_uvm"
      "nvidia_drm"
    ];

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
