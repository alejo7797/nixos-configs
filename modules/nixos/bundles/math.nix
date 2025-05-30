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

    environment = {

      pathsToLink = [
        "/share/KnotJob"
      ];

      systemPackages = with pkgs; [
        gap
        geogebra
        khoca
        knotjob
        lean4
        snappy-math
        texliveFull
        zotero
      ];

    };

    programs.my = {
      jupyter.enable = true;
      regina.enable = true;
      sage.enable = true;
      wolfram.enable = true;
    };

  };
}
