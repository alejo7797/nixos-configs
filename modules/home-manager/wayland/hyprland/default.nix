{ config, lib, pkgs, ... }:

let
  cfg = config.myHome.hyprland;
in

{
  options.myHome.hyprland.enable = lib.mkEnableOption "Hyprland configuration";

  config = lib.mkIf cfg.enable {

    my.wayland.enable = true;

    myHome = {
      wlogout.enable = true;
    };

    # TODO: remove with 25.05.
    services.kanshi.systemdTarget = "graphical-session.target";

    systemd.user.services = lib.mapAttrs

      # Delay the start of graphical systemd user services.
      (_: _: { Unit.After = [ "graphical-session.target" ]; })

      {
        # TODO: Fixed with release 25.05
        gammastep = { };
        hypridle = { };
        kdeconnect-indicator = { };
        network-manager-applet = { };
        waybar = { };
      };

    wayland.windowManager.hyprland = {
      enable = true;

      # Use hy3 to allow for i3-like behaviour.
      plugins = with pkgs.hyprlandPlugins; [ hy3 ];

      # Conflicts with UWSM.
      systemd.enable = false;

      settings =

        let
          uwsm-app = lib.getExe' pkgs.uwsm "uwsm-app";
        in

        {
          "$terminal" = "${uwsm-app} -- kitty.desktop";

          # Make it so that wofi launches applications as units using the UWSM helper.
          # Our implementation requires that `drun-print_desktop_file` be set to true.
          "$menu" = "${uwsm-app} -- $(${lib.getExe pkgs.wofi} || echo true)";

          exec-once = [
            # Workspace autostart command.
            (lib.getExe (pkgs.writeShellApplication {
              name = "hypr-startup";
              runtimeInputs = with pkgs; [ hyprland jq ];
              text = ./hypr-startup;
            }))
          ];

          general = {
            # We don't like gaps.
            gaps_in = 0; gaps_out = 0;

            # Borders for split window layouts.
            border_size = 2; resize_on_border = true;

            layout = "hy3";
          };

          decoration = {
            # No rounding.
            rounding = 0;

            # No opacity effects.
            active_opacity = 1.0;
            inactive_opacity = 1.0;

            # Shadow and blur.
            shadow.enabled = true;
            blur.enabled = true;
          };

          animations = {
            enabled = "yes, please :)";

            bezier = [
              "quick,           0.15, 0,    0.1,  1"
              "easeOutQuint,    0.23, 1,    0.32, 1"
              "almostLinear,    0.5,  0.5,  0.75, 1"
              "linear,          0,    0,    1,    1"
            ];

            animation = [
              # name                on/off  speed   curve           style
              "global,              1,      10,     default"
              "windows,             1,      4.79,   easeOutQuint"
                "windowsIn,         1,      4.1,    easeOutQuint,   popin 87%"
                "windowsOut,        1,      1.49,   linear,         popin 87%"
              "layers,              1,      3.81,   easeOutQuint"
                "layersIn,          1,      4,      easeOutQuint,   fade"
                "layersOut,         1,      1.5,    linear,         fade"
              "fade,                1,      3.03,   quick"
                "fadeIn,            1,      1.73,   almostLinear"
                "fadeOut,           1,      1.46,   almostLinear"
                "fadeLayersIn,      1,      1.79,   almostLinear"
                "fadeLayersOut,     1,      1.39,   almostLinear"
              "border,              1,      5.39,   easeOutQuint"
              "workspaces,          1,      1.94,   almostLinear,   slide"
                "specialWorkspace,  1,      1.94,   almostLinear,   fade"
            ];
          };

          # Assign workspaces to physical monitors.
          workspace = builtins.concatLists (lib.mapAttrsToList
            (o: ws: map (w: "${toString w}, monitor:${o}") ws)
            config.myHome.workspaces);

          # Main modifier key.
          "$mainMod" = "SUPER";

          bind =

            let
              grimblast = lib.getExe pkgs.grimblast;
            in

            map (x: "$mainMod, ${x}") [

              # Basic Hyprland keybindings.
              "Return, exec, $terminal"
              "D, exec, $menu" "F, fullscreen,"

              # Keybind to access logout menu.
              "X, exec, ${lib.getExe pkgs.wlogout}"

              # Move between windows.
              "left, hy3:movefocus, l"
              "right, hy3:movefocus, r"
              "up, hy3:movefocus, u"
              "down, hy3:movefocus, d"

              # With Vim keybindings.
              "h, hy3:movefocus, l"
              "l, hy3:movefocus, r"
              "k, hy3:movefocus, u"
              "j, hy3:movefocus, d"

              # Switch window layouts.
              "w, hy3:makegroup, tab"
              "b, hy3:changegroup, h"
              "v, hy3:changegroup, v"

              # Move between workspaces.
              "1, workspace, 1" "2, workspace, 2"
              "3, workspace, 3" "4, workspace, 4"
              "5, workspace, 5" "6, workspace, 6"
              "7, workspace, 7" "8, workspace, 8"
              "9, workspace, 9" "0, workspace, 10"

              # Toggle the scratchpad workspace.
              "s, togglespecialworkspace, magic"

              # Scroll between workspaces.
              "mouse_down, workspace, m-1"
              "mouse_up, workspace, m+1"
            ]

            ++ map (x: "$mainMod SHIFT, ${x}") [

              # More basic keybindings.
              "Q, killactive," "Space, togglefloating,"

              # Screenshot keyboard shortcuts.
              "X, exec, ${grimblast} copysave area"
              "Z, exec, ${grimblast} copysave output"

              # Move windows around.
              "left, hy3:movewindow, l"
              "right, hy3:movewindow, r"
              "up, hy3:movewindow, u"
              "down, hy3:movewindow, d"

              # With Vim keybindings.
              "h, hy3:movewindow, l"
              "l, hy3:movewindow, r"
              "k, hy3:movewindow, u"
              "j, hy3:movewindow, d"

              # Move between workspaces.
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

              # Send to the scratchpad workspace.
              "S, hy3:movetoworkspace, special:magic"
            ];

          bindel =

            let
              wpctl = lib.getExe' pkgs.wireplumber "wpctl";
              brightnessctl = lib.getExe pkgs.brightnessctl;
            in

            [
              ", XF86AudioRaiseVolume, exec, ${wpctl} set-volume @DEFAULT_AUDIO_SINK@ 4%+"
              ", XF86AudioLowerVolume, exec, ${wpctl} set-volume @DEFAULT_AUDIO_SINK@ 4%-"
              ", XF86AudioMute, exec, ${wpctl} set-mute @DEFAULT_AUDIO_SINK@ toggle"
              ", XF86AudioMicMute, exec, ${wpctl} set-mute @DEFAULT_AUDIO_SOURCE@ toggle"

              ", XF86MonBrightnessUp, exec, ${brightnessctl} s 2%+"
              ", XF86MonBrightnessDown, exec, ${brightnessctl} s 2%-"

              ", switch:on:Lid Switch, exec, hyprctl keyword monitor \"eDP-1, disable\""
              ", switch:off:Lid Switch, exec, hyprctl keyword monitor \"eDP-1, preferred, 1\""
            ];

          bindl =

            let
              playerctl = lib.getExe pkgs.playerctl;
            in

            [
              ", XF86AudioNext, exec, ${playerctl} next"
              ", XF86AudioPause, exec, ${playerctl} play-pause"
              ", XF86AudioPlay, exec, ${playerctl} play-pause"
              ", XF86AudioPrev, exec, ${playerctl} previous"
            ];

          bindm = [
            # Move and resize using the mouse.
            "$mainMod, mouse:272, movewindow"
            "$mainMod, mouse:273, resize_window"
          ];

          bindn = [
            # Focus on windows using the mouse.
            ", mouse:272, hy3:focustab, mouse"
          ];
        };

    };
  };
}
