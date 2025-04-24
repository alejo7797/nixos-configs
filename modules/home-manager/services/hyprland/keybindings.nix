{ lib, pkgs, ... }: {

  wayland.windowManager.hyprland.settings = {

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
        "Return, exec, [float; size 600 480] $terminal"
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
}
