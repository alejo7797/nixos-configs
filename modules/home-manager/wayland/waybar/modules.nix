{ pkgs, lib, config, ... }: {

  programs.waybar.settings.mainBar = let

    workspaces = {
      format = "{icon}";
      format-icons = {
        "1" = "";    # firefox
        "2" = "";    # library
        "3" = "";    # steam
        "4" = "";    # terminal
        "6" = "";    # git
        "8" = "";    # discord
        "9" = "";    # spotify
        "10" = "";   # extra
        urgent = ""; # (!)
      };
    };

  in {

    "sway/workspaces" = workspaces;
    "hyprland/workspaces" = workspaces;

    idle_inhibitor = {
      format = "{icon}";
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
      on-click-right = "audio-switch";
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

    temperature = {
      thermal-zone =
        if config.myHome.hostname == "satsuki" then 7
        else if config.myHome.hostname == "shinobu" then 1
        else null;
      format = "{temperatureC}°C {icon}";
      format-icons = ["" "" ""];
      tooltip = false;
    };

    network = {
      format-wifi = "{essid} ";
      tooltip-format = "{ifname} via {gwaddr}";
    };

    "network#vpn" = {
      interface = "wg0";
      format = "VPN ";
      format-disconnected = "VPN ";
      tooltip = false;
    };

    "network#harvard" = {
      interface = "vpn0";
      format = "Harvard VPN ";
      format-disconnected = "";
    };

    "custom/weather" = {
      format = "{}";
      tooltip = true;
      interval = 1800;
      exec = "wttrbar-wrapper";
      return-type = "json";
    };

    clock = {
      interval = 5;
      format-alt = "{:%Y-%m-%d %H:%M:%S}";
      tooltip-format = "<big>{:%Y %B}</big>\n<tt><small>{calendar}</small></tt>";
   };

    "custom/swaync" = let
      swaync-client = "${pkgs.swaynotificationcenter}/bin/swaync-client";
    in {
      tooltip = false;
      format = "{icon}";
      format-icons = let
        alert = "<span foreground='#cc6666'><sup></sup></span>";
      in{
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
