{ config, lib, pkgs, ... }:

let
  cfg = config.my.desktop;
in

{
  options = {

    my.desktop.enable = lib.mkEnableOption "desktop bundle";

  };

  config = lib.mkIf cfg.enable {

    environment.systemPackages = with pkgs; [

      ffmpeg
      imagemagick
      yt-dlp

    ];

    home-manager.sharedModules = [{

      my.desktop.enable = true;

    }];

  };
}
