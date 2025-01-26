{
  lib,
  config,
  ...
}:

let
  cfg = config.myNixOS.adguardhome;
in

{
  options.myNixOS.adguardhome.enable = lib.mkEnableOption "AdGuard Home";

  config = lib.mkIf cfg.enable {



  };
}
