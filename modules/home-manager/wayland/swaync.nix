{ pkgs, lib, config, ... }: {

  services.swaync = {

    # Enable the swaync daemon.
    enable = true;

    # Configure swaync.
    settings = {
      positionX = "right";
      positionY = "bottom";
      fit-to-screen = false;
    };

  };
}
