{
  lib,
  config,
  ...
}:

let
  cfg = config.myNixOS.sonarr;
in

{
  options.myNixOS.sonarr.enable = lib.mkEnableOption "Sonarr";

  config = lib.mkIf cfg.enable {



  };
}
