{ config, lib, ... }:

let
  cfg = config.services.jellyfin;
in

lib.mkIf cfg.enable {

  services = {

    jellyfin = {

    };

  };

}
