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

      btop

      ffmpeg
      imagemagick
      yt-dlp

    ];

    hardware = {
      gpgSmartcards.enable = true;
      sane.enable = true;
    };

    services = {
      dbus.packages = [ pkgs.gcr ];
    };

    home-manager.sharedModules = [{

      my.desktop.enable = true;

    }];

  };
}
