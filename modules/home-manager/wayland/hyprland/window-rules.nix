{ pkgs, lib, config, ... }: {

  wayland.windowManager.hyprland.settings.windowrulev2 =

    # Default workspaces.
    map (x: "workspace ${toString x.ws} silent, ${x.criteria}") [
      { ws = 1; criteria = "class:^(firefox)$"; }
    ]

    # Floating windows.
    ++ ["float, class:^(blueman-manager)$"
    "float, class:^(firefox)$, title:^(Picture-in-Picture)$"
    "float, class:^(hyprland-share-picker)$"
    "float, class:^(org\\.keepassxc\\.KeePassXC)$"
    "float, class:^(net.lutris.Lutris), title:(Log for .*)$"
    "float, class:^(nm-connection-editor)$"
    "float, class:^(system-config-printer)$"
    "float, class:^(org.pulseaudio.pavucontrol)$"
    "float, class:^(org.prismlauncher.PrismLauncher)$"
    "float, class:^(qt\\dct)$"
    "float, class:^(thunderbird)$, title:^(Calendar Reminders)$"
    "float, class:^(thunderbird)$, title:^(\\d* Reminders?)$"
    "float, class:^(authenticator)$, title:^(Yubico Authenticator)$"

    # System tray.
    "size 600 600, class:^(blueman-manager)$, title:^(Bluetooth Devices)$"
    "move 100%-w-10 100%-w-40, class:^(blueman-manager)$, title:^(Bluetooth Devices)$"

    "size 600 600, class:^(nm-connection-editor)$, title:^(Network Connections)$"
    "move 100%-w-10 100%-w-40, class:^(nm-connection-editor)$, title:^(Network Connections)$"

    "float, class:^(nm-openconnect-auth-dialog)$"
    "size 600 600, class:^(nm-openconnect-auth-dialog)$"
    "move 100%-w-10 100%-w-40, class:^(nm-openconnect-auth-dialog)$"

    "size 600 600, class:^(thunderbird)$, title:^(Calendar Reminders)$"
    "move 100%-w-10 100%-w-40, class:^(thunderbird)$, title:^(Calendar Reminders)$"
    "size 600 600, class:^(thunderbird)$, title:^(\\d* Reminders?)$"
    "move 100%-w-10 100%-w-40, class:^(thunderbird)$, title:^(\\d* Reminders?)$"

    "float, class:^(variety)$, title:^(Variety Images)$"
    "rounding 0, class:^(variety)$, title:^(Variety Images)$"
    "size 1920 120, class:^(variety)$, title:^(Variety Images)$"
    "move 0 100%-w-30, class:^(variety)$, title:^(Variety Images)$"

    # Inhibit idle.
    "idleinhibit fullscreen, class:^(firefox)$"
    "idleinhibit fullscreen, class:^(mpv)$"
    "idleinhibit fullscreen, class:^(steam_app_\\d*)$"

    "idleinhibit, title:^(.* - YouTube — Mozilla Firefox)$"
    "idleinhibit, class:^(Zoom Workplace)$"

    # Dolphin dialogs
    "move onscreen cursor -50% -50%, class:^(org.kde.dolphin)$, floating:1"

    "float, class:^(org.kde.dolphin)$, title:^(Creating directory — Dolphin)$"
    "noinitialfocus, class:^(org.kde.dolphin)$, title:^(Creating directory — Dolphin)$"
    "size 450 200, class:^(org.kde.dolphin)$, title:^(Creating directory — Dolphin)$"
    "move 100%-w-10 100%-w-52, class:^(org.kde.dolphin)$, title:^(Creating directory — Dolphin)$"

    "float, class:^(org.kde.dolphin)$, title:^(Deleting — Dolphin)$"
    "noinitialfocus, class:^(org.kde.dolphin)$, title:^(Deleting — Dolphin)$"
    "size 450 160, class:^(org.kde.dolphin)$, title:^(Deleting — Dolphin)$"
    "move 100%-w-10 100%-w-40, class:^(org.kde.dolphin)$, title:^(Deleting — Dolphin)$"

    "float, class:^(org.kde.dolphin)$, title:^(Deleting — Dolphin)$"
    "noinitialfocus, class:^(org.kde.dolphin)$, title:^(Copying — Dolphin)$"
    "size 450 225, class:^(org.kde.dolphin)$, title:^(Copying — Dolphin)$"
    "move 100%-w-10 100%-w-40, class:^(org.kde.dolphin)$, title:^(Copying — Dolphin)$"

    "float, class:^(org.kde.dolphin)$, title:^(Progress Dialog — Dolphin)$"
    "noinitialfocus, class:^(org.kde.dolphin)$, title:^(Progress Dialog — Dolphin)$"
    "size 450 200, class:^(org.kde.dolphin)$, title:^(Progress Dialog — Dolphin)$"
    "move 100%-w-10 100%-w-52, class:^(org.kde.dolphin)$, title:^(Progress Dialog — Dolphin)$"

    # Ignore maximize requests from apps. You'll probably like this.
    "suppressevent maximize, class:.*"

    # Fix some dragging issues with XWayland.
    "nofocus, class:^$, title:^$, xwayland:1, floating:1, fullscreen:0, pinned:0"

    # XWaylandVideoBridge
    "opacity 0.0 override, class:^(xwaylandvideobridge)$"
    "noanim, class:^(xwaylandvideobridge)$"
    "noinitialfocus, class:^(xwaylandvideobridge)$"
    "maxsize 1 1, class:^(xwaylandvideobridge)$"
    "noblur, class:^(xwaylandvideobridge)$"
    "nofocus, class:^(xwaylandvideobridge)$"

  ];
}
