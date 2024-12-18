{ lib, pkgs, ... }: {

  home.username = "ewan";
  home.homeDirectory = "/home/ewan";
  home.stateVersion = "24.11";

  myHome.style.enable = true;

  # Configure the zsh shell.
  programs.zsh = {
    enable = true;
    history.save = 5000;
  };

  # Configure sway.
  wayland.windowManager.sway = {
    enable = true;
    wrapperFeatures.gtk = true;
    extraSessionCommands = ''
      export _JAVA_AWT_WM_NONREPARENTING=1
      export QT_WAYLAND_DISABLE_WINDOWDECORATION=1
      export QT_IM_MODULE=fcitx
    '';
    systemd.variables = lib.mkOptionDefault [
      "QT_FONT_DPI"
      "QT_QPA_PLATFORMTHEME"
    ];
    config = let
      modifier = "Mod4";
      exit = "exit: [s]leep, [h]ibernate, [r]eboot, [p]oweroff";
    in {
      inherit modifier;
      terminal = "kitty";
      menu = "wofi | xargs swaymsg exec --";
      bars = [ { command = "waybar"; } ];
      fonts = lib.mkForce {
        names = [ "Noto Sans Medium" ];
        size = 12.0;
      };
      keybindings = lib.mkOptionDefault {
        "${modifier}+x" = "mode ${exit}";
        "${modifier}+Shift+x" = "exec slurpshot";
      };
      gaps = {
        inner = 0;
        outer = 0;
      };
      window.hideEdgeBorders = "both";
      defaultWorkspace = "workspace number 1";
      startup = [
        { command = "xrdb -load ~/.Xresources"; }
        { command = "systemctl --user start xsettingsd"; }
        { command = "systemctl --user start gnome-polkit-agent"; }
        { command = "dex --autostart --environment sway"; }
        { command = "kdeconnect-indicator"; }
        { command = "gammastep-indicator"; }
        { command = "swayidle"; }
        { command = "swaync"; }
      ];
      modes = lib.mkOptionDefault {
        ${exit} = {
          s = "systemctl suspend-then-hibernate, mode default";
          h = "systemctl hibernate, mode default";
          p = "systemctl poweroff";
          r = "systemctl reboot";
          Escape = "mode default";
          "${modifier}+x" = "mode default";
        };
      };
    };
  };

  # Install and configure wofi.
  programs.wofi = {
    enable = true;
    settings = {
      show = "drun";
      allow_images = true;
    };
  };

  # Install and configure kitty.
  programs.kitty = {
    enable = true;
  };

  # Install and configure waybar.
  programs.waybar = {
    enable = true;
  };

}
