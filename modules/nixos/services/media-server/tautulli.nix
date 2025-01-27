{
  lib,
  config,
  ...
}:

let
  cfg = config.myNixOS.tautulli;
in

{
  options.myNixOS.tautulli.enable = lib.mkEnableOption "Tautulli";

  config = lib.mkIf cfg.enable {



  };
}
