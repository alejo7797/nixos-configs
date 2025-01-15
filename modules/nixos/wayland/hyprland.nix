{
  lib,
  config,
  ...
}:

{
  options.myNixOS.hyprland.enable = lib.mkEnableOption "Hyprland";

  config = lib.mkIf config.myNixOS.hyprland.enable {

    myNixOS.wayland.enable = true;

    programs.hyprland = {
      enable = true;
      withUWSM = true;
    };
  };
}
