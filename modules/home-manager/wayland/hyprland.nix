{ pkgs, lib, config, ... }: {

  options.myHome.hyprland.enable = lib.mkEnableOption "Hyprland configuration";

  config = lib.mkIf config.myHome.hyprland.enable {

    # Install and configure a bunch of wayland-specific utilities.
    myHome.wayland.enable = true;

    # Configure Hyprland, the tiling Wayland compositor.
    wayland.windowManager.hyprland = {
      enable = true;

    };
  };
}
