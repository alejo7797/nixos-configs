{
  lib,
  config,
  ...
}:

let
  cfg = config.myNixOS.mediaserver;
in

{
  options.myNixOS.mediaserver.enable = lib.mkEnableOption "media server functionality";

  config = lib.mkIf cfg.enable {

    myNixOS = {
      # Set up a reverse proxy.
      nginx.enable = true;

      # Media server module.
      plex.enable = true;

      # Plex companion apps.
      kometa.enable = true;
      tautulli.enable = true;

      # Main download client.
      rutorrent.enable = true;

      # Notification service.
      notifiarr.enable = true;

      # Indexer management.
      autobrr.enable = true;
      flaresolverr.enable = true;
      prowlarr.enable = true;

      # The *Arr suite.
      bazarr.enable = true;
      radarr.enable = true;
      sonarr.enable = true;

      # Download extraction.
      unpackerr.enable = true;
    };

    users.groups = {
      media = { gid = 1001; };
    };
  };
}
