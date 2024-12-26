{ pkgs, lib, config, ... }: {

  wayland.windowManager.sway.config = {

    # Workspace assignments.
    assigns = {
      "1" = [
        { app_id = "^firefox$"; }
        { app_id = "^thunderbird$"; }
        { class = "^Joplin$"; }
      ];
      "2" = [{ app_id = "^Zotero$"; }];
      "3" = [
        { class = "^steam$"; }
        { class = "^steam_app_\d*"; }
        { title = "^Minecraft\* 1\.\d{1,2}\.\d$"; }
      ];
      "8" = [{ class = "^vesktop$"; }];
      "9" = [{ class = "^Spotify$"; }];
    };

    # Floating windows.
    floating.criteria = [
        { window_type = "dialog"; }
        { window_role = "dialog"; }
        { app_id = "^blueman-manager$"; }
        { app_id = "^org\\.keepassxc\\.KeePassXC$"; }
        { app_id = "^lutris$"; title = "Log for .*"; }
        { app_id = "^nm-connection-editor$"; }
        { app_id = "^nm-openconnect-auth-dialog$"; }
        { app_id = "^org\\.pulseaudio\\.pavucontrol$"; }
        { app_id = "^qt\\dct$"; }
        { class = "^XEyes$"; }
        { title = "^Yubico Authenticator$"; }

    ];

    window.commands =

      # System tray.
      map (w: w // { command = "resize set 600 600, move position 1320 448"; }) [
        { criteria = { app_id = "^blueman-manager$"; title = "^Bluetooth Devices$"; }; }
        { criteria = { app_id = "^nm-connection-editor$"; title = "^Network Connections$"; }; }
        { criteria.app_id = "^nm-openconnect-auth-dialog$"; }
      ]

      # Variety wallpaper selector.
      ++ [{
        criteria = {app_id = "^variety$"; title = "^Variety Images$"; };
        command = "floating enable, border none, move position 0 930";
      }]

      # Idle inhibit when fullscreen.
      ++ map (w: w // { command = "inhibit_idle fullscreen"; }) [
        { criteria.app_id = "^firefox$"; }
        { criteria.app_id = "^mpv$"; }
        { criteria.class = "^steam_app_\d*$"; }
      ]

      # Idle inhibit always.
      ++ map (w: w // { command = "inhibit_idle"; }) [
        { criteria.title = "^.* - YouTube — Mozilla Firefox$"; }
        { criteria.app_id = "^Zoom Workplace$"; }
      ]

      # Dolphin dialogs.
      ++ [{
        command = "float, no_focus, resize set 450 160, move position 1460 880";
        criteria = {
          app_id = "^org\\.kde\\.dolphin$";
          title = "^(Creating directory|Copying|Moving|Deleting|Progress Dialog) — Dolphin$";
        };
      }]

      # XWaylandVideoBridge.
      ++ [{
        criteria.class = "^xwaylandvideobridge$";
        command = "floating enable, resize set 50 50, move position 1920 -50";
      }];

  };
}
