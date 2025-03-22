{ config, lib, ... }:

let
  cfg = config.my.laptop;
in

{
  options = {

    my.laptop.enable = lib.mkEnableOption "laptop bundle";

  };

  config = lib.mkIf cfg.enable {

    my.desktop.enable = true;

    services = {
      auto-cpufreq.enable = true;
      thermald.enable = true;
    };

    home-manager.sharedModules = [{

      my.laptop.enable = true;

    }];

  };
}
