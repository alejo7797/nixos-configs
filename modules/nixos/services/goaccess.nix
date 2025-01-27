{
  lib,
  config,
  ...
}:

let
  cfg = config.myNixOS.goaccess;
in

{
  options.myNixOS.goaccess.enable = lib.mkEnableOption "GoAccess";

  config = lib.mkIf cfg.enable {



  };
}
