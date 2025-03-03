{
  pkgs,
  config,
  ...
}:

let
  cfg = config.myHome.waybar;
in

{
  programs.waybar.settings.mainBar =

    let
      workspaces = {
        format = "{icon}";
        format-icons = {
          "1" = ""; # firefox
          "2" = ""; # library
          "3" = ""; # steam
          "4" = ""; # terminal
          "6" = ""; # coding
          "8" = ""; # discord
          "9" = ""; # spotify
          "10" = ""; # extra
        };
      };
    in

    {
      "sway/workspaces" = workspaces;
      "hyprland/workspaces" = workspaces;

      "sway/scratchpad" = {
        format = "{icon} {count}";
        format-icons = ["" ""];
      };

      idle_inhibitor = {
        format = "{icon}";
        format-icons = {
          activated = "";
          deactivated = "";
        };
      };

      systemd-failed-units = {
	      format = "{nr_failed} ";
      };

      pulseaudio = {
        scroll-step = 1; # Make precise adjustments.
        format-bluetooth = "{volume}% {icon}{format_source}";
        format = "{volume}% {icon}{format_source}";

        format-muted = " ";
        # Only show when source is on.
        format-source = " {volume}% ";
        format-source-muted = "";

        on-click = "${pkgs.pavucontrol}/bin/pavucontrol";
        format-icons = { default = ["" "" ""]; headphone = ""; headset = ""; };
        on-click-right = "${pkgs.audio-switch}/bin/audio-switch";
      };

      cpu = {
        format = "{usage}% ";
      };

      memory = {
        format = "{}% ";
      };

      disk = {
        interval = 30; path = "/";
        format = "{percentage_used}% ";
      };

      battery = {
        format = "{capacity}% {icon}";
        format-charging = "{capacity}% ";
        format-plugged = "{capacity}% ";
        format-alt = "{time} {icon}";

        states = { warning = 30; critical = 15; };
        format-icons = [ "" "" "" "" "" ];
      };

      temperature = {
        inherit (cfg) thermal-zone;
        format = "{temperatureC}°C {icon}";
        format-icons = ["" "" ""];
      };

      network = {
        format-wifi = "{essid} ";
        format-alt = "{ifname}: {ipaddr}/{cidr}";
        tooltip-format = "{ifname} via {gwaddr}";
      };

      "network#vpn" = {
        interface = "wg0"; format = "VPN ";
        format-alt = "{ifname}: {ipaddr}/{cidr}";
        format-disconnected = "VPN ";
      };

      "network#harvard" = {
        interface = "tun0"; format = "Harvard VPN ";
        format-disconnected = ""; # Don't show normally.
        format-alt = "{ifname}: {ipaddr}/{cidr}";
      };

      "custom/wttr" = {
        format = "{}";
        interval = 1800;
        return-type = "json";
        tooltip = true;

        exec = ''
          ${pkgs.wttrbar}/bin/wttrbar \
            --custom-indicator "{FeelsLikeC}°C {ICON}" \
            --location "${cfg.location}"
        '';
      };

      clock = {
        interval = 5; format-alt = "{:%Y-%m-%d %H:%M:%S}"; # Cute calendar pop-up.
        tooltip-format = "<big>{:%Y %B}</big>\n<tt><small>{calendar}</small></tt>";
      };

      "custom/swaync" =
        let
          alert = "<span foreground='#${red}'><sup></sup></span>";
          client = "${pkgs.swaynotificationcenter}/bin/swaync-client";
          red = config.lib.stylix.colors.base08; # Alert icon color.
        in
        {
          escape = true;
          format = "{icon}";
          return-type = "json";
          tooltip = false;

          format-icons = {
            notification = "${alert}"; dnd-none = "";
            dnd-notification = "${alert}"; none = "";
          };

          exec = "${client} -swb"; # Run client daemon process.
          on-click = "${client} -t -sw"; # Open swaync dashboard.
          on-click-right = "${client} -d -sw"; # Do not disturb.
        };

      tray = {
        spacing = 10;
      };
    };

}
