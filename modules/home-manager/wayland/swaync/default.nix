{
  lib,
  config,
  ...
}:
let
  cfg = config.myHome.swaync;
in
{
  options.myHome.swaync.enable = lib.mkEnableOption "SwayNotificationCenter";

  config = lib.mkIf cfg.enable {

    # Style swaync ourselves.
    stylix.targets.swaync.enable = false;

    services.swaync = {
      enable = true;

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

      style = ./style.css;
    };
  };
}
