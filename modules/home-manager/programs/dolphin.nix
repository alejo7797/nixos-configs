{
  lib,
  config,
  ...
}:

let
  cfg = config.myHome.dolphin;
in

{
  options.myHome.dolphin.enable = lib.mkEnableOption "Dolphin configuration";

  config = lib.mkIf cfg.enable {

    xdg.configFile."dolphinrc".text = lib.generators.toINI {} {

      DetailsMode = {
        IconSize = 22;
        PreviewSize = 22;
        SidePadding = 21;
      };

      "KFileDialog Settings" = {
        "Places Icons Auto-resize" = false;
        "Places Icons Static Size" = 22;
      };

      MainWindow = {
        MenuBar = "Disabled";
        ToolBarsMovable = "Disabled";
      };

    };
  };
}
