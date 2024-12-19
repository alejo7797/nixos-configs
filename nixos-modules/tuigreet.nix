{ pkgs, lib, config, ... }: {

  options.myNixOS.tuigreet.enable = lib.mkEnableOption "tuigreet";

  config = lib.mkIf config.myNixOS.tuigreet.enable  {

    # Enable greetd.
    services.greetd = {
      enable = true;
      settings = {
        default_session = let

          # Use tuigreet as our greeter.
          tuigreet = "${pkgs.greetd.tuigreet}/bin/tuigreet";

          # Start Hyprland using UWSM.
          hyprland = "${pkgs.hyprland}/bin/Hyprland";
          hyprland-uwsm = "${pkgs.uwsm}/bin/uwsm start -S -F ${hyprland}";

          # Launch Hyprland by default when available.
          default =
            if config.myNixOS.hyprland.enable then "${hyprland-uwsm}"
            else if config.myNixOS.sway.enable then "sway"
            else "zsh";

        in {
            command = "${tuigreet} --cmd ${default}";
            user = "greeter";
        };

      };
    };

    # As opposed to when using SDDM, we need this
    # to be available early on in the login process.
    environment.variables.QT_FONT_DPI = 120;

  };

}
