{
  lib,
  config,
  ...
}:

let
  cfg = config.myNixOS.notifiarr;
in

{
  options.myNixOS.notifiarr.enable = lib.mkEnableOption "Notifiarr";

  config = lib.mkIf cfg.enable {

    # virtualisation.oci-containers.containers.notifiarr = {
    #
    # };

  };
}
