{ config, lib, pkgs, ... }:

let
  cfg = config.my.math;
in

{
  options.my.math.enable = lib.mkEnableOption "math bundle";

  config = lib.mkIf cfg.enable {

    home-manager.sharedModules = [
      { my.math.enable = true; }
    ];

    environment.systemPackages = with pkgs; [
      gap
      geogebra
      khoca
      knotjob
      mathematica-webdoc
      regina-normal
      sage
      snappy-math
      texliveFull
      zotero
    ];

    programs = {
      my.jupyter.enable = true;
    };

  };
}
