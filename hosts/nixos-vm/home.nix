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
    package = null;
    config = {
      modifier = "Mod4";
      terminal = "kitty";
      menu = "wofi | xargs swaymsg exec --";
      bars = [ { command = "waybar"; } ];
      fonts = lib.mkForce {
        names = [ "Noto Sans Medium" ];
        size = 12.0;
      };
      keybindings = lib.mkOptionDefault {
        "Mod4+Shift+x" = "exec slurpshot";
      };
      gaps = {
        inner = 0;
        outer = 0;
      };
      window.hideEdgeBorders = "both";
      defaultWorkspace = "workspace number 1";
      startup = [
        { command = "swayidle"; }
        { command = "swaync"; }
        { command = "kdeconnect-indicator"; }
        { command = "gammastep-indicator"; }
        { command = "dex --autostart --environment sway"; }
        { command = "ststemctl --user start gnome-polkit-agent"; }
        { command = "systemctl --user import-environment QT_FONT_DPI QT_QPA_PLATFORMTHEME"; }
        { command = "dbus-update-activation-environment --systemd QT_FONT_DPI QT_QPA_PLATFORMTHEME"; }
      ];
    };
    extraConfig = ''
      #
      # Exit mode
      #
      set $exit "exit: [s]leep, [h]ibernate, [r]eboot, [p]oweroff"
      mode $exit {
          bindsym --to-code {
              s exec systemctl suspend-then-hibernate, mode "default"
              h exec systemctl hibernate, mode "default"
              p exec systemctl poweroff
              r exec systemctl reboot

              Escape mode "default"
              Mod4+x mode "default"
          }
      }
      bindsym --to-code Mod4+x mode $exit
    '';
  };

  # Use wofi as our application runner.
  programs.wofi = {
    enable = true;
    settings = {
      show = "drun";
      allow_images = true;
    };
  };

  # Use kitty as our terminal emulator.
  programs.kitty = {
    enable = true;
  };

  # Enable and configure waybar.
  programs.waybar = {
    enable = true;
  };

}
