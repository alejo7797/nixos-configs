{ pkgs, lib, config, ... }: {

  options.myNixOS.sway.enable = lib.mkEnableOption "sway";

  config = lib.mkIf config.myNixOS.sway.enable {

    # Install a bunch of Wayland-specific goodies.
    myNixOS.wayland.enable = true;

    # Install sway, the i3-compatible Wayland compositor.
    programs.sway = {

      enable = true;
      wrapperFeatures.gtk = true;
      extraPackages = [ ];

      # Let sway now if we are using Nvidia drivers.
      extraOptions = lib.mkIf config.myNixOS.nvidia.enable [ "--unsupported-gpu" ];

    };

    # Configure UWSM to manage sway.
    programs.uwsm = {
      enable = true;
      waylandCompositors.sway = {
        prettyName = "Sway";
        binPath = "/run/current-system/sw/bin/sway";
        comment = "Sway compositor managed by UWSM";
      };
    };

  };
}
