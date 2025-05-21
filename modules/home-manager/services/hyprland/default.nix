{ config, lib, pkgs, ... }:

let
  cfg = config.wayland.windowManager.hyprland;
in

{
  options = {

    wayland.windowManager.hyprland.my.workspaces = lib.mkOption {
      description = "Hyprland workspace output assignments.";
      type = with lib.types; attrsOf ( listOf (oneOf [ int str ]) );
      default = { }; example = { "DP-1" = [ "web" "dev" ]; };
    };

  };

  config = lib.mkIf cfg.enable {

    # TODO: migrate elsewhere
    my.wayland.enable = true;

    wayland.windowManager.hyprland = {

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
            cfg.my.workspaces);

        };

    };
  };
}
