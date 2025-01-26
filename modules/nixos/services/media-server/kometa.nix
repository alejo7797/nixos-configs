{
  lib,
  config,
  ...
}:

let
  cfg = config.myNixOS.kometa;
in

{
  options.myNixOS.kometa.enable = lib.mkEnableOption "Kometa & ImageMaid";

  config = lib.mkIf cfg.enable {

    virtualisation.oci-containers.containers = {

      kometa = { };

      imagemaid = { };

    };
  };
}
