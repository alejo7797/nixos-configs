{ pkgs, lib, config, ... }: {

  options.myNixOS.tuigreet.enable = lib.mkEnableOption "tuigreet";

  config = lib.mkIf config.myNixOS.tuigreet.enable  {

    # Enable greetd.
    services.greetd = {
      enable = true;
      settings = {

        # Use tuigreet as the greeter.
        default_session = {
            command = "${pkgs.greetd.tuigreet}/bin/tuigreet --cmd sway";
            user = "greeter";
        };

      };
    };

  };

}
