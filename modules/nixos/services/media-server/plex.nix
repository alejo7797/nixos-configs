{
  lib,
  config,
  ...
}:

let
  cfg = config.myNixOS.plex;
in

{
  options.myNixOS.plex.enable = lib.mkEnableOption "Plex Media Server";

  config = lib.mkIf cfg.enable {



  };
}
