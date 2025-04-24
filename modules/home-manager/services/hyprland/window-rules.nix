{ lib, ... }: {

  wayland.windowManager.hyprland.settings.windowrulev2 =

    let
      dolphin-dialogs = lib.concatStrings [

        "title:^(Copying|Deleting|Moving)"

        # Sometimes the percentage progress is
        # present in the initial window title.
        ''( \(\d+\% of [\d\.]+ \w+\))?''

        " — Dolphin$"
      ];
    in

    # Assign applications to their default workspaces.
    map (w: "workspace ${toString w.ws} silent, ${w.criteria}")
    [
      # Workspace 1 contains my web browser and email client.
      { ws = 1; criteria = "title:^(\\.+ - )?Mozilla Firefox$"; }
      { ws = 2; criteria = "title:^(Home - )?Mozilla Thunderbird$"; }

      { ws = 5; criteria = "class:^steam$"; }

      { ws = 8; criteria = "class:^signal$"; }
      { ws = 8; criteria = "class:^vesktop$"; }
      { ws = 8; criteria = "class:^Altus$"; }

      { ws = 9; criteria = "class:^spotify$"; }

      { ws = 18; criteria = "class:^Zotero$"; }
    ]

    # Smart window borders configuration.
    ++ [
      "bordersize 0, floating:0, onworkspace:w[tv1]"
      "bordersize 0, floating:0, onworkspace:f[1]"
      "rounding 12, floating:1"
    ]

    # Make sure these windows are made to float.
    ++ map (w: "float, ${w}") [

      # Firefox Picture-in-Picture video player.
      "class:^(firefox)$, title:^Picture-in-Picture$"

      # Thunderbird calendar reminder pop-up.
      "class:^(thunderbird)$, title:^(Calendar|\\d+) Reminder(s)?$"

      # System tray applications.
      "class:^nm-connection-editor$"
      "class:^.blueman-manager-wrapped$"
      "class:^org.kde.kdeconnect.handler$"
      "class:^org.pulseaudio.pavucontrol$"
      "class:^system-config-printer$"

      # These float too.
      dolphin-dialogs

      # Other goodies we like to keep floating.
      "class:^org\\.keepassxc\\.KeePassXC$"
      "class:^net.lutris.Lutris$, title:^Log for .*$"
      "class:^variety$, title:^Variety Images$"
    ]

    # System tray dialogs.
    ++ builtins.concatMap

      # Set both comfortable window position and size.
      (w: [ "size 600 600, ${w}" "move 100%-w-10 100%-w-40, ${w}" ])

      [
        "class:^.blueman-manager-wrapped$, title:^Bluetooth Devices$"
        "class:^org.kde.kdeconnect.handler$, title:^KDE Connect URL handler$"
        "class:^nm-connection-editor$, title:^Network Connections$"
        "class:^thunderbird$, title:^(Calendar|\\d+) Reminder(s)?$"
      ]

    # Move the Variety wallpaper selector into its natural position.
    ++ map (e: "${e}, class:^variety$, title:^Variety Images$") [
      "bordersize 0" "rounding 0" "size 1920 120" "move 0 100%-w-30"
    ]

    # Make these inhibit hypridle when fullscreen.
    ++ map (c: "idleinhibit fullscreen, class:^${c}$") [
      "firefox" "mpv" "plex-desktop" "steam_app_\\d*"
    ]

    # Make Dolphin popups show up near the mouse cursor.
    ++ [ "move onscreen cursor -50% -50%, class:^(org.kde.dolphin)$, floating:1" ]

    # Make Dolphin dialogs show up above the system tray.
    ++ [
      "size 450 265, ${dolphin-dialogs}"
      "move 100%-w-10 100%-w-40, ${dolphin-dialogs}"
      "noinitialfocus, ${dolphin-dialogs}"
    ]

    ++ [
      # Ignore maximize requests from apps.
      "suppressevent maximize, class:.*"

      # Fix some dragging issues with XWayland. Recommended configuration.
      "nofocus, class:^$, title:^$, xwayland:1, floating:1, fullscreen:0, pinned:0"
    ]

    # XWaylandVideoBridge window rules.
    ++ map (e: "${e}, class:^(xwaylandvideobridge)$") [
      "opacity 0.0 override" "noinitialfocus"
      "maxsize 1 1" "noanim" "noblur" "nofocus"
    ];

}
