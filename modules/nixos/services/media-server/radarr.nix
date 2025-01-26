{
  lib,
  config,
  ...
}:

let
  cfg = config.myNixOS.radarr;
in

{
  options.myNixOS.radarr.enable = lib.mkEnableOption "Radarr";

  config = lib.mkIf cfg.enable {



  };
}
