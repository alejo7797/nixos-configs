{ pkgs, lib, config, ... }: {

  wayland.windowManager.hyprland.settings.windowrulev2 =

    let
      dolphin-dialogs = lib.concatStringsSep " "
        [
          "class:^(org.kde.dolphin)$,"
          "title:^(Creating directory|Copying|Moving|Deleting|Progress Dialog) — Dolphin$"
        ];
    in

    # Default workspaces.
    map (w: "workspace ${toString w.ws} silent, ${w.criteria}") [
      { ws = 1; criteria = "class:^(firefox)$"; }
      { ws = 1; criteria = "class:^(firefox)$"; }
      { ws = 1; criteria = "title:^((Home - )?Mozilla Thunderbird)$"; }
      { ws = 1; criteria = "class:^(@joplin\\/app-desktop)$"; }
      { ws = 2; criteria = "class:^(Zotero)$"; }
      { ws = 3; criteria = "title:^(Minecraft\\* 1\\.\\d{1,2}\\.\\d)$"; }
      { ws = 3; criteria = "class:^(steam)$"; }
      { ws = 3; criteria = "class:^(steam_app_\\d*)$"; }
      { ws = 6; criteria = "class:^(code-oss)$"; }
      { ws = 8; criteria = "class:^(vesktop)$"; }
      { ws = 9; criteria = "class:^(spotify)$"; }
    ]

    # Floating windows.
    ++ map (w: "float, ${w}") [
      "class:^(blueman-manager)$"
      "class:^(firefox)$, title:^(Picture-in-Picture)$"
      "class:^(hyprland-share-picker)$"
      "class:^(org\\.keepassxc\\.KeePassXC)$"
      "class:^(net.lutris.Lutris), title:(Log for .*)$"
      "class:^(nm-connection-editor)$"
      "class:^(nm-openconnect-auth-dialog)$"
      "class:^(system-config-printer)$"
      "class:^(org.pulseaudio.pavucontrol)$"
      "class:^(org.prismlauncher.PrismLauncher)$"
      "class:^(thunderbird)$, title:^(Calendar Reminders)$"
      "class:^(thunderbird)$, title:^(\\d* Reminders?)$"
      "class:^(variety)$, title:^(Variety Images)$"
      "class:^(authenticator)$, title:^(Yubico Authenticator)$"
    ]

    # System tray.
    ++ lib.concatLists (
      map (w: [ "size 600 600, ${w}" "move 100%-w-10 100%-w-40, ${w}" ]) [
        "class:^(blueman-manager)$, title:^(Bluetooth Devices)$"
        "class:^(nm-connection-editor)$, title:^(Network Connections)$"
        "class:^(nm-openconnect-auth-dialog)$"
        "class:^(thunderbird)$, title:^(Calendar Reminders)$"
        "class:^(thunderbird)$, title:^(\\d* Reminders?)$"
      ]
    )

    # Variety wallpaper selector.
    ++ map (e: "${e}, class:^(variety)$, title:^(Variety Images)$") [
      "rounding 0" "size 1920 120" "move 0 100%-w-30"
    ]

    # Inhibit idle when fullscreen.
    ++ map (w: "idleinhibit fullscreen, ${w}") [
      "class:^(firefox)$"
      "class:^(mpv)$"
      "class:^(steam_app_\\d*)$"
    ]

    # Inhibit idle always.
    ++ map (w: "idleinhibit, ${w}") [
      "title:^(.* - YouTube — Mozilla Firefox)$"
      "class:^(Zoom Workplace)$"
    ]

    # Dolphin popups.
    ++ [
      "move onscreen cursor -50% -50%, class:^(org.kde.dolphin)$, floating:1"
    ]

    # Dolphin dialogs
    ++ [
      "float, ${dolphin-dialogs}"
      "noinitialfocus, ${dolphin-dialogs}"
      "size 450 225, ${dolphin-dialogs}"
      "move 100%-w-10 100%-w-40, ${dolphin-dialogs}"
    ]

    ++ [
      # Ignore maximize requests from apps. You'll probably like this.
      "suppressevent maximize, class:.*"

      # Fix some dragging issues with XWayland.
      "nofocus, class:^$, title:^$, xwayland:1, floating:1, fullscreen:0, pinned:0"
    ]

    # XWaylandVideoBridge
    ++ map (e: "${e}, class:^(xwaylandvideobridge)$") [
      "opacity 0.0 override" "noanim" "noinitialfocus"
      "maxsize 1 1" "noblur" "nofocus"
    ];

}
