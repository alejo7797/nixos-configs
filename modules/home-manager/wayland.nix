{ config, lib, ... }:

let
  cfg = config.my.wayland;
in

{
  options.my.wayland.enable = lib.mkEnableOption "Wayland";

  config = lib.mkIf cfg.enable {

    xdg.configFile."uwsm/env".text = ''

      # Wayland fixes.
      export _JAVA_AWT_WM_NONREPARENTING=1
      export QT_WAYLAND_DISABLE_WINDOWDECORATION=1

    '';

    programs.zsh.profileExtra = ''
      if uwsm check may-start; then
        exec uwsm start default
      fi
    '';

  };
}
