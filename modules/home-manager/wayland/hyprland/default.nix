{ pkgs, lib, config, ... }: {

  imports = [ ./hy3.nix ./window-rules.nix ];

  options.myHome.hyprland.enable = lib.mkEnableOption "Hyprland configuration";

  config = lib.mkIf config.myHome.hyprland.enable {

    # Install and configure a bunch of wayland-specific utilities.
    myHome.wayland.enable = true;

    # Install and configure wlogout.
    myHome.wlogout.enable = true;

    # Configure Hyprland, the tiling Wayland compositor.
    wayland.windowManager.hyprland = {
      enable = true;

      # Use hy3 for i3-like behaviour.
      plugins = with pkgs.hyprlandPlugins; [ hy3 ];

      # Prevent conflicts with UWSM.
      systemd.enable = false;

      settings =
        let
          uwsm-app = "${pkgs.uwsm}/bin/uwsm-app";
        in
        {
          # Default terminal application.
          "$terminal" = "${uwsm-app} -- ${pkgs.kitty}/bin/kitty";

          # Default application launcher.
          "$menu" = lib.concatStringsSep " " [
            "${pkgs.wofi}/bin/wofi | "
            "${pkgs.findutils}/bin/xargs "
            "${uwsm-app} -- \${1:?}"
          ];

          # Workspace autostart command.
          exec-once = [ "${./hypr-startup}" ];

          # Basic look and feel.
          general = {
            gaps_in = 0;
            gaps_out = 0;
            border_size = 0;
            resize_on_border = true;
            layout = "hy3";
          };

          # Window decorations.
          decoration = {
            rounding = 0;
            active_opacity = 1.0;
            inactive_opacity = 1.0;

            shadow = {
              enabled = true;
              range = 4;
              render_power = 3;
            };

            blur = {
              enabled = true;
              size = 3;
              passes = 1;
              vibrancy = 0.1696;
            };
          };

          # Animations.
          animations = {
            enabled = "yes, please :)";

            bezier = [
              "easeOutQuint,0.23,1,0.32,1"
              "easeInOutCubic,0.65,0.05,0.36,1"
              "linear,0,0,1,1"
              "almostLinear,0.5,0.5,0.75,1.0"
              "quick,0.15,0,0.1,1"
            ];

            animation = [
              "global, 1, 10, default"
              "border, 1, 5.39, easeOutQuint"
              "windows, 1, 4.79, easeOutQuint"
              "windowsIn, 1, 4.1, easeOutQuint, popin 87%"
              "windowsOut, 1, 1.49, linear, popin 87%"
              "fadeIn, 1, 1.73, almostLinear"
              "fadeOut, 1, 1.46, almostLinear"
              "fade, 1, 3.03, quick"
              "layers, 1, 3.81, easeOutQuint"
              "layersIn, 1, 4, easeOutQuint, fade"
              "layersOut, 1, 1.5, linear, fade"
              "fadeLayersIn, 1, 1.79, almostLinear"
              "fadeLayersOut, 1, 1.39, almostLinear"
              "workspaces, 1, 1.94, almostLinear, fade"
              "workspacesIn, 1, 1.21, almostLinear, fade"
              "workspacesOut, 1, 1.94, almostLinear, fade"
            ];
          };

          # Miscellaneous.
          misc = {
            force_default_wallpaper = 2;
            disable_hyprland_logo = false;
          };

          # Keybindings.
          "$mainMod" = "SUPER";
          bind =

            let
              grimblast = "${pkgs.grimblast}/bin/grimblast";
            in

            map (x: "$mainMod, ${x}") [
              "Return, exec, $terminal"
              "D, exec, $menu"
              "F, fullscreen,"
              "X, exec, ${pkgs.wlogout}/bin/wlogout"

              "left, hy3:movefocus, l"
              "right, hy3:movefocus, r"
              "up, hy3:movefocus, u"
              "down, hy3:movefocus, d"

              "h, hy3:movefocus, l"
              "l, hy3:movefocus, r"
              "k, hy3:movefocus, u"
              "j, hy3:movefocus, d"

              "w, hy3:makegroup, tab"
              "b, hy3:changegroup, h"
              "v, hy3:changegroup, v"

              "1, workspace, 1"
              "2, workspace, 2"
              "3, workspace, 3"
              "4, workspace, 4"
              "5, workspace, 5"
              "6, workspace, 6"
              "7, workspace, 7"
              "8, workspace, 8"
              "9, workspace, 9"
              "0, workspace, 10"

              "s, togglespecialworkspace, magic"

              "mouse_down, workspace, e+1"
              "mouse_up, workspace, e-1"
            ]

            ++ map (x: "$mainMod SHIFT, ${x}") [
              "Q, killactive,"
              "Space, togglefloating,"

              "X, exec, ${grimblast} copysave area"
              "Z, exec, ${grimblast} copysave output"

              "left, hy3:movewindow, l"
              "right, hy3:movewindow, r"
              "up, hy3:movewindow, u"
              "down, hy3:movewindow, d"

              "h, hy3:movewindow, l"
              "l, hy3:movewindow, r"
              "k, hy3:movewindow, u"
              "j, hy3:movewindow, d"

              "1, hy3:movetoworkspace, 1"
              "2, hy3:movetoworkspace, 2"
              "3, hy3:movetoworkspace, 3"
              "4, hy3:movetoworkspace, 4"
              "5, hy3:movetoworkspace, 5"
              "6, hy3:movetoworkspace, 6"
              "7, hy3:movetoworkspace, 7"
              "8, hy3:movetoworkspace, 8"
              "9, hy3:movetoworkspace, 9"
              "0, hy3:movetoworkspace, 10"

              "S, hy3:movetoworkspace, special:magic"
            ];

          bindel =
            let
              wpctl = "${pkgs.wireplumber}/bin/wpctl";
              brightnessctl = "${pkgs.brightnessctl}/bin/brightnessctl";
            in
            [
              ", XF86AudioRaiseVolume, exec, ${wpctl} set-volume @DEFAULT_AUDIO_SINK@ 4%+"
              ", XF86AudioLowerVolume, exec, ${wpctl} set-volume @DEFAULT_AUDIO_SINK@ 4%-"
              ", XF86AudioMute, exec, ${wpctl} set-mute @DEFAULT_AUDIO_SINK@ toggle"
              ", XF86AudioMicMute, exec, ${wpctl} set-mute @DEFAULT_AUDIO_SOURCE@ toggle"
              ", XF86MonBrightnessUp, exec, ${brightnessctl} s 2%+"
              ", XF86MonBrightnessDown, exec, ${brightnessctl} s 2%-"
            ];

          bindl =
            let
              playerctl = "${pkgs.playerctl}/bin/playerctl";
            in
            [
              ", XF86AudioNext, exec, ${playerctl} next"
              ", XF86AudioPause, exec, ${playerctl} play-pause"
              ", XF86AudioPlay, exec, ${playerctl} play-pause"
              ", XF86AudioPrev, exec, ${playerctl} previous"
            ];

          bindm = map (x: "$mainMod, ${x}") [
            "mouse:272, movewindow"
            "mouse:273, resize_window"
          ];

          bindn = [
            ", mouse:272, hy3:focustab, mouse"
          ];
        };

    };
  };
}
