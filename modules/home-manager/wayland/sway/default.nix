{
  lib,
  config,
  pkgs,
  ...
}:

let
  cfg = config.myHome.sway;
in

{
  options.myHome.sway.enable = lib.mkEnableOption "sway configuration";

  config = lib.mkIf cfg.enable {

    # Install and configure a bunch of wayland-specific utilities.
    myHome.wayland.enable = true;

    # Set environment variables using UWSM.
    xdg.configFile."uwsm/env-sway".text = ''

      # https://fcitx-im.org/wiki/Using_Fcitx_5_on_Wayland#Sway.
      export QT_IM_MODULE=fcitx

      # Run Electron apps under XWayland.
      export NIXOS_OZONE_WL=

    '';

    # Configure sway, the i3-compatible Wayland compositor.
    wayland.windowManager.sway = {
      enable = true;

      # We install sway via its NixOS module.
      package = null;

      config =

        let
          modifier = "Mod4";
          exit = "exit: [s]leep, [h]ibernate, [r]eboot, [p]oweroff";
          uwsm-app = "${pkgs.uwsm}/bin/uwsm-app";
          kitty = "${config.programs.kitty.package}/bin/kitty";
        in

        {
          inherit modifier;

          # Default terminal application.
          terminal = "${uwsm-app} -- ${kitty}";

          # Default application launcher.
          menu = "${uwsm-app} -- $(${pkgs.wofi}/bin/wofi)";

          # We use waybar instead.
          bars = [ ];

          # Override automatic Stylix settings.
          fonts = lib.mkForce {
            names = [ "Noto Sans Medium" ];
            size = 12.0;
          };

          gaps = { inner = 0; outer = 0; };
          workspaceLayout = "tabbed";
          window.border = lib.mkForce 1;

          workspaceOutputAssign = builtins.concatLists (
            lib.mapAttrsToList
              (o: ws: map (w: { workspace = toString w; output = o; }) ws)
              config.myHome.workspaces
          );

          keybindings =

            let
              brightnessctl = "${pkgs.brightnessctl}/bin/brightnessctl";
              grimshot = "${pkgs.sway-contrib.grimshot}/bin/grimshot";
              loginctl = "${pkgs.systemd}/bin/loginctl";
              pactl = "${pkgs.pulseaudio}/bin/pactl";
              playerctl = "${pkgs.playerctl}/bin/playerctl";
            in

            lib.mkOptionDefault {

              "${modifier}+x" = "mode \"${exit}\"";
              "${modifier}+Shift+o" = "exec ${loginctl} lock-session";
              "${modifier}+Shift+x" = "exec ${grimshot} savecopy output";

              # Use pactl to adjust volume in PulseAudio.
              "XF86AudioRaiseVolume" = "exec ${pactl} set-sink-volume @DEFAULT_SINK@ +4%";
              "XF86AudioLowerVolume" = "exec ${pactl} set-sink-volume @DEFAULT_SINK@ -4%";
              "XF86AudioMute" = "exec ${pactl} set-sink-mute @DEFAULT_SINK@ toggle";
              "XF86AudioMicMute" = "exec ${pactl} set-source-mute @DEFAULT_SOURCE@ toggle";

              # Bind the media keys to playerctl actions.
              "XF86AudioPlay" = "exec ${playerctl} play-pause";
              "XF86AudioPause" = "exec ${playerctl} pause";
              "XF86AudioNext" = "exec ${playerctl} next";
              "XF86AudioPrev" = "exec ${playerctl} previous";

              # Control the screen brightness.
              "XF86MonBrightnessDown" = "exec ${brightnessctl} set 2%-";
              "XF86MonBrightnessUp" = "exec ${brightnessctl} set 2%+";

            };

          startup =
            [
              { command = "${./sway-startup}"; }
              { command = "${./clamshell}"; always = true; }
            ];

          modes = lib.mkOptionDefault {
            ${exit} = {
              s = "exec systemctl suspend, mode default";
              h = "exec systemctl hibernate, mode default";
              p = "exec systemctl poweroff";
              r = "exec systemctl reboot";
              Escape = "mode default";
            };
          };
        };

    };
  };
}
