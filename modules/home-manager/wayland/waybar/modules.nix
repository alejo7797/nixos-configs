{
  config,
  pkgs,
  ...
}:

let
  cfg = config.myHome.waybar;
  stylix-colors = config.lib.stylix.colors;
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
          "6" = ""; # git
          "8" = ""; # discord
          "9" = ""; # spotify
          "10" = ""; # extra
          "urgent" = ""; # (!)
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

      pulseaudio = {
        scroll-step = 1;
        format = "{volume}% {icon}{format_source}";
        format-bluetooth = "{volume}% {icon}";
        format-bluetooth-muted = " {icon}";
        format-muted = " ";
        format-source = " {volume}% ";
        format-source-muted = "";
        format-icons = {
          headphone = "";
          hands-free = "";
          headset = "";
          phone = "";
          portable = "";
          car = "";
          default = ["" "" ""];
        };
        on-click = "${pkgs.pavucontrol}/bin/pavucontrol";
        on-click-right = "${pkgs.audio-switch}/bin/audio-switch";
      };

      cpu = {
        tooltip = false;
        format = "{usage}% ";
      };

      memory = {
        format = "{}% ";
      };

      disk = {
        interval = 30;
        format = "{percentage_used}% ";
        path = "/";
      };

      battery = {
        states = {
          warning = 30;
          critical = 15;
        };
        format = "{capacity}% {icon}";
        format-charging = "{capacity}% ";
        format-plugged = "{capacity}% ";
        format-alt = "{time} {icon}";
        format-icons = [ "" "" "" "" "" ];
      };

      temperature = {
        inherit (cfg) thermal-zone;
        format = "{temperatureC}°C {icon}";
        format-icons = ["" "" ""];
        tooltip = false;
      };

      network = {
        format-wifi = "{essid} ";
        format-alt = "{ifname}: {ipaddr}/{cidr}";
        tooltip-format = "{ifname} via {gwaddr}";
      };

      "network#vpn" = {
        interface = "wg0";
        format = "VPN ";
        format-disconnected = "VPN ";
        format-alt = "{ifname}: {ipaddr}/{cidr}";
        tooltip = false;
      };

      "network#harvard" = {
        interface = "tun0";
        format = "Harvard VPN ";
        format-disconnected = "";
        format-alt = "{ifname}: {ipaddr}/{cidr}";
        tooltip = false;
      };

      "custom/wttr" = {
        format = "{}";
        tooltip = true;
        interval = 1800;
        exec = ''
          ${pkgs.wttrbar}/bin/wttrbar \
          --custom-indicator "{temp_C}°C {ICON}" \
          --location "${cfg.wttr-location}"
        '';
        return-type = "json";
      };

      clock = {
        interval = 5;
        format-alt = "{:%Y-%m-%d %H:%M:%S}";
        tooltip-format = "<big>{:%Y %B}</big>\n<tt><small>{calendar}</small></tt>";
      };

      "custom/swaync" =
        let
          swaync-client = "${pkgs.swaynotificationcenter}/bin/swaync-client";
        in
        {
          tooltip = false;
          format = "{icon}";
          format-icons =
            let
              alert = "<span foreground='#${stylix-colors.base08}'><sup></sup></span>";
            in
            {
              notification = "${alert}";
              none = "";
              dnd-notification = "${alert}";
              dnd-none = "";
              inhibited-notification = "${alert}";
              inhibited-none = "";
              dnd-inhibited-notification = "${alert}";
              dnd-inhibited-none = "";
            };
          return-type = "json";
          exec = "${swaync-client} -swb";
          on-click = "${swaync-client} -t -sw";
          on-click-right = "${swaync-client} -d -sw";
          escape = true;
        };

      tray = {
        spacing = 10;
      };
    };
}
