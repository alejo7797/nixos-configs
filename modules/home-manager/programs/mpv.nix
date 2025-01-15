{
  lib,
  config,
  pkgs,
  ...
}:

let
  cfg = config.myHome.mpv;
in

{
  options.myHome.mpv.enable = lib.mkEnableOption "mpv";

  config = lib.mkIf cfg.enable {

    programs.mpv = {
      enable = true;

      config = {
        profile = "gpu-hq";
        save-position-on-quit = true;
      };

      scripts = with pkgs.unstable; [
        mpvScripts.builtins.autoload
        mpvScripts.autosub
      ];
    };
  };
}
