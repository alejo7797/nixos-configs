{ config, lib, pkgs, ... }:

let
  cfg = config.my.gaming;
in

{
  options.my.gaming.enable = lib.mkEnableOption "gaming bundle";

  config = lib.mkIf cfg.enable {

    environment.systemPackages = with pkgs; [
      azahar
      bolt-launcher
      dosbox-x
      easyrpg-player
      gamescope
      lutris
      mangohud
      prismlauncher
    ];

    programs = {
      gamemode.enable = true;
      steam.protontricks.enable = true;
      my.retroarch.enable = true;
    };

  };
}
