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
    };

  };

}
