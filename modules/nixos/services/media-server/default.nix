{
  lib,
  config,
  ...
}:

let
  cfg = config.myNixOS.mediaServer;
in

{
  imports = [
    ./autobrr.nix ./bazarr.nix
    ./plex.nix ./prowlarr.nix
    ./radarr.nix ./rutorrent.nix
    ./sonarr.nix ./tautulli.nix
  ];

  options.myNixOS.mediaServer.enable = lib.mkEnableOption "media server functionality";

  config = lib.mkIf cfg.enable {

    myNixOS = {
      # Set up a reverse proxy.
      nginx.enable = true;

      # Friendly dashboard.
      homepage.enable = true;

      # Media server module.
      plex.enable = true;

      # Friendly statistics.
      tautulli.enable = true;

      # Main download client.
      rutorrent.enable = true;

      # The *Arr suite.
      autobrr.enable = true;
      bazarr.enable = true;
      prowlarr.enable = true;
      radarr.enable = true;
      sonarr.enable = true;
    };

    systemd.services = {

      # Extract downloaded archives.
      unpackerr = { };

    };

    virtualisation.oci-containers.containers = {

      # Proxy bypass services.
      flaresolverr = { };

      # Notifications service.
      notifiarr = { };

    };
  };
}
