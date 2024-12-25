{ pkgs, lib, config, ... }: {

  imports = [ ./window-rules.nix ];

  options.myHome.sway.enable = lib.mkEnableOption "sway configuration";

  config = lib.mkIf config.myHome.sway.enable {

    # Install and configure a bunch of wayland-specific utilities.
    myHome.wayland.enable = true;

    # Configure sway, the i3-compatible Wayland compositor.
    wayland.windowManager.sway = {
      enable = true;

      # We install sway via a NixOS module.
      package = null;

      config = let

        modifier = "Mod4";
        exit = "exit: [s]leep, [h]ibernate, [r]eboot, [p]oweroff";
        uwsm_app = "${pkgs.uwsm}/bin/uwsm app --";
        systemctl = "${pkgs.systemd}/bin/systemctl";

      in {

        inherit modifier;
        terminal = "${uwsm_app} ${pkgs.kitty}/bin/kitty";
        menu = "${pkgs.wofi}/bin/wofi | ${pkgs.findutils}/bin/xargs swaymsg exec ${uwsm_app}";
        bars = [ ];

        # Override automatic Stylix settings.
        fonts = lib.mkForce {
          names = [ "Noto Sans Medium" ];
          size = 12.0;
        };

        gaps = { inner = 0; outer = 0; };
        window.hideEdgeBorders = "both";
        workspaceLayout = "tabbed";

        keybindings = let

          brightnessctl = "${pkgs.brightnessctl}/bin/brightnessctl";
          loginctl = "${pkgs.systemd}/bin/loginctl";
          pactl = "${pkgs.pulseaudio}/bin/pactl";
          playerctl = "${pkgs.playerctl}/bin/playerctl";

        in lib.mkOptionDefault {

          "${modifier}+x" = "mode \"${exit}\"";
          "${modifier}+Shift+o" = "exec ${loginctl} lock-session";
          "${modifier}+Shift+x" = "exec slurpshot";

          # Use pactl to adjust volume in PulseAudio.
          "XF86AudioRaiseVolume" = "exec ${pactl} set-sink-volume @DEFAULT_SINK@ +4%";
          "XF86AudioLowerVolume" = "exec ${pactl} set-sink-volume @DEFAULT_SINK@ -4%";
          "XF86AudioMute"        = "exec ${pactl} set-sink-mute @DEFAULT_SINK@ toggle";
          "XF86AudioMicMute"     = "exec ${pactl} set-source-mute @DEFAULT_SOURCE@ toggle";

          # Bind the media keys to playerctl actions.
          "XF86AudioPlay"  = "exec ${playerctl} play-pause";
          "XF86AudioPause" = "exec ${playerctl} pause";
          "XF86AudioNext"  = "exec ${playerctl} next";
          "XF86AudioPrev"  = "exec ${playerctl} previous";

          # Control the screen brightness.
          "XF86MonBrightnessDown" = "exec ${brightnessctl} set 2%-";
          "XF86MonBrightnessUp"   = "exec ${brightnessctl} set 2%+";

        };

        startup = [
          { command = "${pkgs.xorg.xrdb}/bin/xrdb -load ~/.Xresources"; }
          { command = "${uwsm_app} ${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1"; }
          { command = "${pkgs.bash}/bin/bash ${./sway-startup}"; }
        ];

        modes = lib.mkOptionDefault {
          ${exit} = {
            s = "exec ${systemctl} suspend, mode default";
            h = "exec ${systemctl} hibernate, mode default";
            p = "exec ${systemctl} poweroff";
            r = "exec ${systemctl} reboot";
            Escape = "mode default";
          };
        };

      };
    };
  };
}
