{ pkgs, lib, config, ... }: {

  options.myHome.hyprland.enable = lib.mkEnableOption "hyprland";

  config = lib.mkIf config.myHome.hyprland.enable {

  };

}
