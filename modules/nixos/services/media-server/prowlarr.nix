{
  lib,
  config,
  ...
}:

let
  cfg = config.myNixOS.prowlarr;
in

{
  options.myNixOS.prowlarr.enable = lib.mkEnableOption "Prowlarr";

  config = lib.mkIf cfg.enable {



  };
}
