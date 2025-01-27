{
  lib,
  config,
  ...
}:

let
  cfg = config.myNixOS.bazarr;
in

{
  options.myNixOS.bazarr.enable = lib.mkEnableOption "Bazarr";

  config = lib.mkIf cfg.enable {



  };
}
