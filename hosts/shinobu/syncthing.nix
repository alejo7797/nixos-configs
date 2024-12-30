{ pkgs, lib, config, ... }: {

  config.services.syncthing = {

    # Run Syncthing as a user service.
    enable = true;

  };
}
