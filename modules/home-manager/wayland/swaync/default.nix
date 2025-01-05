{ pkgs, lib, config, ... }: let

  cfg = config.myHome.swaync;

in {

  options.myHome.swaync.enable = lib.mkEnableOption "the sway notification center";

  config = lib.mkIf cfg.enable {

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
        control-center-margin-right = 10;
        control-center-margin-bottom = 10;

        notification-icon-size = 32;
        notification-window-width = 360;
      };

      # Style swaync.
      style = ./style.css;
    };
  };
}
