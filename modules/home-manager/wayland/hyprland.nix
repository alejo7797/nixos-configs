{ pkgs, lib, config, ... }: {

  options.myHome.hyprland.enable = lib.mkEnableOption "Hyprland configuration";

  config = lib.mkIf config.myHome.hyprland.enable {

  };

}
