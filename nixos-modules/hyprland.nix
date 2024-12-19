{ pkgs, lib, config, ... }: {

  options.myNixOS.hyprland.enable = lib.mkEnableOption "Hyprland";

  config = lib.mkIf config.myNixOS.hyprland.enable {

    # Install a bunch of Wayland-specific goodies.
    myNixOS.wayland.enable = true;

    # Install Hyprland, and let UWSM manage it.
    programs.hyprland = {
      enable = true;
      withUWSM = true;
    };

  };
}
