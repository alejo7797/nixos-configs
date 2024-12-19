{ pkgs, lib, config, ... }: {

  options.myHome.sway.enable = lib.mkEnableOption "sway";

  config = lib.mkIf config.myHome.sway.enable {

    # Configure a bunch of wayland-specific utilities.
    myHome.wayland.enable = true;

    # Configure sway, the i3-compatible Wayland compositor.
    wayland.windowManager.sway = {

      enable = true;
      wrapperFeatures.gtk = true;

      extraSessionCommands = ''
        export _JAVA_AWT_WM_NONREPARENTING=1
        export QT_WAYLAND_DISABLE_WINDOWDECORATION=1
        export QT_IM_MODULE=fcitx
      '';

      systemd = {
        xdgAutostart = true;
        variables = lib.mkOptionDefault [
          "QT_FONT_DPI"
          "QT_QPA_PLATFORMTHEME"
        ];
      };

      config = let
        modifier = "Mod4";
        exit = "exit: [s]leep, [h]ibernate, [r]eboot, [p]oweroff";
      in {

        inherit modifier;
        terminal = "${pkgs.kitty}/bin/kitty";
        menu = "${pkgs.wofi}/bin/wofi | ${pkgs.findutils}/bin/xargs swaymsg exec --";
        bars = [ { command = "${pkgs.waybar}/bin/waybar"; } ];

        fonts = lib.mkForce {
          names = [ "Noto Sans Medium" ];
          size = 12.0;
        };

        gaps = { inner = 0; outer = 0; };
        window.hideEdgeBorders = "both";
        defaultWorkspace = "workspace number 1";

        keybindings = lib.mkOptionDefault {
          "${modifier}+x" = "mode \"${exit}\"";
          "${modifier}+Shift+x" = "exec slurpshot";
        };

        startup = [
          { command = "${pkgs.xorg.xrdb}/bin/xrdb -load ~/.Xresources"; }
          { command = "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1"; }
          { command = "${pkgs.kdePackages.kdeconnect-kde}/bin/kdeconnect-indicator"; }
          { command = "${pkgs.gammastep}/bin/gammastep-indicator"; }
        ];

        modes = lib.mkOptionDefault {
          ${exit} = {
            s = "systemctl suspend, mode default";
            h = "systemctl hibernate, mode default";
            p = "systemctl poweroff";
            r = "systemctl reboot";
            Escape = "mode default";
          };
        };

      };

    };

  };

}
