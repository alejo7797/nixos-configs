{
  lib,
  config,
  ...
}:

let
  cfg = config.myNixOS.autobrr;
in

{
  options.myNixOS.autobrr.enable = lib.mkEnableOption "Autobrr";

  config = lib.mkIf cfg.enable {



  };
}
