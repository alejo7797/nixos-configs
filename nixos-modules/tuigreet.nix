{ pkgs, lib, config, ... }: {

  options.myNixOS.tuigreet.enable = lib.mkEnableOption "tuigreet";

  config = lib.mkIf config.myNixOS.tuigreet.enable  {

    # Enable greetd.
    services.greetd = {
      enable = true;
      settings = {
        default_session = let

          # Use tuigreet as our greeter.
          tuigreet = "${pkgs.tuigreet}/bin/tuigreet";

          # Launch Hyprland by default when available.
          default_environment =
            if config.myNixOS.hyprland.enable then "Hyprland"
            else if config.myNixOS.sway.enable then "sway"
            else "zsh --login";

        in {
            command = "${tuigreet} --cmd ${default_environment}";
            user = "greeter";
        };

      };
    };

    # As opposed to when using SDDM, we need this
    # to be available early on in the login process.
    environment.variables.QT_FONT_DPI = 120;

  };

}
