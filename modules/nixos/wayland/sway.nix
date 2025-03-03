{
  lib,
  config,
  ...
}:
{

  options.myNixOS.sway.enable = lib.mkEnableOption "sway";

  config = lib.mkIf config.myNixOS.sway.enable {

    myNixOS.wayland.enable = true;

    programs.sway = {
      enable = true;
      wrapperFeatures.gtk = true;
      extraPackages = [ ];

      # Let sway now when we are using Nvidia drivers.
      extraOptions = lib.mkIf config.my.nvidia.enable [ "--unsupported-gpu" ];
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
