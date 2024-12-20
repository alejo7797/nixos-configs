{ pkgs, lib, config, ... }: let

    cfg = config.myNixOS.tuigreet;

in {

  options.myNixOS.tuigreet = {

    enable = lib.mkEnableOption "tuigreet";

    user_session = lib.mkOption {
      type = lib.types.enum [ "sway" "hyprland" "zsh" ];
      description = "Default session to run after login.";
      default = "zsh";
    };

  };

  config = lib.mkIf cfg.enable  {

    services.greetd = {
      enable = true;
      settings = {
        default_session = let

          # Use UWSM to manage sway and Hyprland.
          uwsm-start = "${pkgs.uwsm}/bin/uwsm start -S -F";

          sessions = {
            hyprland = "'${uwsm-start} ${pkgs.hyprland}/bin/Hyprland'";
            sway = "'${uwsm-start} ${pkgs.sway}/bin/sway'";
          };

          command = lib.concatStringsSep " " [

            # Use tuigreet as our greeter.
            "${pkgs.greetd.tuigreet}/bin/tuigreet"

            # Remember the last used session.
            "--remember" "--remember-session"

            # Set the default user session.
            ("--cmd " + sessions.${cfg.user_session})

          ];

        in { inherit command; user = "greeter"; };
      };
    };

    # As opposed to when using SDDM, we need this
    # to be available early on in the login process.
    environment.variables.QT_FONT_DPI = 120;

  };

}
