{ config, lib, pkgs, ... }:

let
  cfg = config.my.math;
in

{
  options.my.math.enable = lib.mkEnableOption "math bundle";

  config = lib.mkIf cfg.enable {

    environment.systemPackages = with pkgs; [
      gap
      geogebra
      khoca
      knotjob
      mathematica-webdoc
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
