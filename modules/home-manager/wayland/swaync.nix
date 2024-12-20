{ pkgs, lib, config, ... }: {

  # Enable and configure swaync.
  services.swaync = {
    enable = true;
  };

}
