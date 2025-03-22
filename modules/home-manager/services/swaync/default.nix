{ config, lib, ... }:

let
  cfg = config.services.swaync;
in

lib.mkIf cfg.enable {

  # TODO: move somewhere else?
  stylix.targets.swaync.enable = false;

  services.swaync = {
    settings = {
      positionX = "right";
      positionY = "bottom";
      fit-to-screen = false;

      control-center-width = 400;
      control-center-height = 480;
      control-center-margin-right = 10;
      control-center-margin-bottom = 10;

      notification-icon-size = 32;
      notification-window-width = 360;
    };

    # TODO: stylix
    style = ./style.css;
  };
}
