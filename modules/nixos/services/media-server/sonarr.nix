{
  lib,
  config,
  ...
}:

let
  cfg = config.myNixOS.sonarr;
in

{
  options.myNixOS.sonarr.enable = lib.mkEnableOption "Sonarr";

  config = lib.mkIf cfg.enable {

    services.sonarr = {
      enable = true;

      # We ensure the media group exists.
      group = config.users.groups.media.name;
    };

  };
}
