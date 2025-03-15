{
  lib,
  config,
  pkgs,
  ...
}:

let
  cfg = config.myHome.wlogout;

  wlogout-icons = pkgs.stdenv.mkDerivation {
    name = "wlogout-icons"; src = pkgs.wlogout;
    nativeBuildInputs = [ pkgs.imagemagick ];
    buildPhase = ''
      for f in share/wlogout/icons/*; do
        magick "$f" -alpha extract -background white -alpha shape "$f"
      done
    '';
    installPhase = ''
      for f in share/wlogout/icons/*; do
        install -Dm644 "$f" -t $out
      done
    '';
  };
in

{
  options.myHome.wlogout.enable = lib.mkEnableOption "wlogout";

  config = lib.mkIf cfg.enable {

    # Install and configure wlogout.
    programs.wlogout = {
      enable = true;

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
          action = "hyprctl dispatch exec uwsm stop";
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
          color: #ffffff;
          background-color: #1d1f21;
          background-position: center;
          background-repeat: no-repeat;
          background-size: 25%;
          border-radius: 0;
          border-width: 0;
        }

        button:active, button:hover {
          background-color: #81a2be;
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
  };
}
