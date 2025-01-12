{
  lib,
  config,
  ...
}:

let
  cfg = config.myHome.zathura;
in

{
  options.myHome.zathura.enable = lib.mkEnableOption "Zathura configuration";

  config.programs.zathura = lib.mkIf cfg.enable {

    enable = true;

    options = {
      selection-clipboard = "clipboard";
      guioptions = "shv";
    };

  };
}
