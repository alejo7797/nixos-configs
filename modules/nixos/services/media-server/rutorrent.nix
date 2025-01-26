{
  lib,
  config,
  ...
}:

let
  cfg = config.myNixOS.rutorrent;
in

{
  options.myNixOS.rutorrent.enable = lib.mkEnableOption "ruTorrent";

  config = lib.mkIf cfg.enable {



  };
}
