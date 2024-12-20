{ pkgs, lib, config, ... }: {

  options.myHome.hyprland.enable = lib.mkEnableOption "hyprland configuration";

  config = lib.mkIf config.myHome.hyprland.enable {

  };

}
