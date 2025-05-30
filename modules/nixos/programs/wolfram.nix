{ config, lib, pkgs, ... }:

let
  cfg = config.programs.my.wolfram;
in

{
  options.programs.my.wolfram.enable = lib.mkEnableOption "Wolfram Mathematica";

  config = lib.mkIf cfg.enable {

    environment = {

      pathsToLink = [ "/share/Wolfram"];

      systemPackages = with pkgs; [ knottheory mathematica-webdoc ];

      variables = {

        WOLFRAM_BASE = "/run/current-system/sw/share/Wolfram";

      };

    };
  };
}
