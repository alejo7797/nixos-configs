{ config, lib, pkgs, ... }:

let
  cfg = config.my.desktop;
in

{
  options = {

    my.desktop.enable = lib.mkEnableOption "desktop bundle";

  };

  config = lib.mkIf cfg.enable {

    programs = {
      direnv.enable = true;
      lsd.enable = true;
      nixvim.enable = true;
    };

    services = {
      my.variety.enable = true;
    };

    home.packages = with pkgs; [
      favicon-generator
      round-corners
      sleep-deprived
    ];

  };
}
