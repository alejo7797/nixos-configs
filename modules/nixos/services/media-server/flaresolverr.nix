{
  lib,
  config,
  ...
}:

let
  cfg = config.myNixOS.flaresolverr;
in

{
  options.myNixOS.flaresolverr.enable = lib.mkEnableOption "FlareSolverr";

  config = lib.mkIf cfg.enable {

    # virtualisation.oci-containers.containers.flaresolverr = {
    #
    # };

  };
}
