{ config, lib, pkgs, ... }:

let
  cfg = config.programs.waybar;
in

{
  programs.waybar.settings.mainBar = {

    "hyprland/workspaces" =  {
      format = "{icon}";
      format-icons = {
        "1" = "󰈹"; # firefox
        "2" = ""; # emails
        "3" = ""; # latex
        "4" = ""; # terminal
        "5" = ""; # games
        "6" = ""; # coding
        "8" = ""; # messaging
        "9" = ""; # media

        "18" = ""; # library
        "20" = ""; # btop

        "30" = ""; # extra
      };
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

      format-muted = "";
      # Only show when source is on.
      format-source = " {volume}% ";
      format-source-muted = "";

      on-click = lib.getExe pkgs.pavucontrol;
      format-icons = { default = ["" "" ""]; headphone = ""; headset = ""; };
      on-click-right = lib.getExe pkgs.audio-switch;
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
      inherit (cfg.my) thermal-zone;
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
        ${lib.getExe pkgs.wttrbar} \
          --custom-indicator "{FeelsLikeC}°C {ICON}" \
          --location "${cfg.my.location}"
      '';
    };

    clock = {
      interval = 5; format-alt = "{:%Y-%m-%d %H:%M:%S}"; # Cute calendar pop-up.
      tooltip-format = "<big>{:%Y %B}</big>\n<tt><small>{calendar}</small></tt>";
    };

    "custom/swaync" =
      let
        alert = "<span foreground='#${red}'><sup></sup></span>";
        client = lib.getExe' pkgs.swaynotificationcenter "swaync-client";
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
