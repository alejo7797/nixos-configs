{ pkgs, lib, config, ... }: let

  cfg = config.myNixOS.tuigreet;

in {

  options.myNixOS.tuigreet.enable = lib.mkEnableOption "tuigreet";

  config = lib.mkIf cfg.enable  {

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
  };
}
