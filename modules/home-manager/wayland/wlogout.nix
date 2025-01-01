{ pkgs, lib, config, ... }: {

  options.myHome.wlogout.enable = lib.mkEnableOption "wlogout";

  config = lib.mkIf config.myHome.wlogout.enable {

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
          action = "hyprctl dispatch exit";
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

      style =

        let
          icon-path = "${pkgs.wlogout}/share/wlogout/icons";
        in

        ''
          window {
            background-color: rgba(12,12,12,0.4);
          }

          button {
            color: #c5c8c6;
            font-size: 18px;
            background-color: #1d1f21;
            border-radius: 0;
            border-color: black;
          }

          button:focus {
            outline-style: none;
          }

          button:active,
          button:hover {
            color: #1d1f21;
            background-color: #81a2be;
            outline-style: none;
          }
        ''

        # Smart icon-path configuration.
        + lib.concatStringsSep "\n" (

            map

              (a:
                ''
                  #${a} {
                    background-image: image(
                      url("${icon-path}/${a}.png")
                    )
                  }
                ''
              )

              [
                "lock" "logout"
                "suspend" "hibernate"
                "shutdown" "reboot"
              ]

        );

    };
  };
}
