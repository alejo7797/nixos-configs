{ pkgs, lib, config, ... }: {

  options.myNixOS.tuigreet.enable = lib.mkEnableOption "tuigreet";

  config = lib.mkIf config.myNixOS.tuigreet.enable  {

    services.greetd = {
      enable = true;
      settings = {
        default_session = {

          command = lib.concatStringsSep " " [

            # Use tuigreet as our greeter.
            "${pkgs.greetd.tuigreet}/bin/tuigreet"

            # Remember the last used session.
            "--remember" "--remember-session"

          ];

          user = "greeter";

        };
      };
    };

    # As opposed to when using SDDM, we need this
    # to be available early on in the login process.
    environment.variables = {
      QT_FONT_DPI = 120;
      QT_QPA_PLATFORMTHEME = "qt5ct";
    };

  };
}
