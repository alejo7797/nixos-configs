{ pkgs, lib, config, ... }: {

  # Style swaync ourselves.
  stylix.targets.swaync.enable = false;

  services.swaync = {

    # Enable the swaync daemon.
    enable = true;

    # Configure swaync.
    settings = {
      positionX = "right";
      positionY = "bottom";
      fit-to-screen = false;
      control-center-width = 400;
      control-center-height = 480;
      notification-icon-size = 32;
      notification-window-width = 360;
    };

    # Style swaync.
    style = ./style.css;

  };
}
