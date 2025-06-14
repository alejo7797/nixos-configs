{ config, pkgs, ... }:

let
  inherit (config.lib.stylix) colors;

  wlogout-icons = pkgs.runCommand "wlogout-icons"
    {
      nativeBuildInputs = [ pkgs.imagemagick ];
      inherit (pkgs) wlogout;
    }
    ''
      mkdir -p "$out"
      for f in $wlogout/share/wlogout/icons/*; do
        magick "$f" -alpha extract -background white -alpha shape "$out/$(basename "$f")"
      done
    '';
in

{
  programs.wlogout = {
    layout = [
      {
        label = "lock";
        action = "loginctl lock-session";
        text = "Lock";
        keybind = "l";
      }
      {
        label = "hibernate";
        action = "systemctl hibernate";
        text = "Hibernate";
        keybind = "h";
      }
      {
        label = "logout";
        action = "uwsm stop";
        text = "Logout";
        keybind = "e";
      }
      {
        label = "shutdown";
        action = "systemctl poweroff";
        text = "Shutdown";
        keybind = "S";
      }
      {
        label = "suspend";
        action = "systemctl suspend";
        text = "Suspend";
        keybind = "s";
      }
      {
        label = "reboot";
        action = "systemctl reboot";
        text = "Reboot";
        keybind = "r";
      }
    ];

    style = ''
      * {
        background-image: none;
        box-shadow: none;
      }

      window {
        background-color: rgba(12,12,12,0.4);
      }

      button {
        font-size: 18px;
        color: #${colors.base07};
        background-color: #${colors.base00};
        background-position: center;
        background-repeat: no-repeat;
        background-size: 25%;
        border-radius: 0;
        border-width: 0;
      }

      button:active, button:hover {
        background-color: #${colors.base0D};
      }

      button:focus {
        outline-style: none;
      }

      #lock {
        background-image: image(url("${wlogout-icons}/lock.png"));
      }

      #logout {
        background-image: image(url("${wlogout-icons}/logout.png"));
      }

      #suspend {
        background-image: image(url("${wlogout-icons}/suspend.png"));
      }

      #hibernate {
        background-image: image(url("${wlogout-icons}/hibernate.png"));
      }

      #shutdown {
        background-image: image(url("${wlogout-icons}/shutdown.png"));
      }

      #reboot {
        background-image: image(url("${wlogout-icons}/reboot.png"));
      }
    '';
  };
}
