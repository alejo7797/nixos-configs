{ config, lib, ... }:

let
  cfg = config.my.media-server;
in

{
  options.my.media-server.enable = lib.mkEnableOption "media server bundle";

  config = lib.mkIf cfg.enable {

    myNixOS = {
      # Main download client.
      rutorrent.enable = true;

      # Indexer management.
      autobrr.enable = true;
      flaresolverr.enable = true;

      # The *Arr suite.
      bazarr.enable = true;

      # Download extraction.
      unpackerr.enable = true;
    };

    services = {
      jellyfin.enable = true;
      nginx.enable = true;
      prowlarr.enable = true;
      radarr.enable = true;
      sonarr.enable = true;
    };

    users.groups = {
      media.gid = 1001;
    };

  };
}
