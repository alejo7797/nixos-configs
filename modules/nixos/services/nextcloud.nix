{
  lib,
  config,
  ...
}:

let
  cfg = config.myNixOS.nextcloud;
in

{
  options.myNixOS.nextcloud.enable = lib.mkEnableOption "Nextcloud server";

  config = lib.mkIf cfg.enable {



  };
}
