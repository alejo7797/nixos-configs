{ config, lib, ... }: {

  options.xdg.autostart = {

    my.entries = lib.mkOption {

      type = with lib.types; listOf (

        # Simple case.
        either package

        (
          submodule {

            package = lib.mkOption {
              type = package;
              description = ''
                Package with desktop file to autostart.
              '';
            };

            filename = lib.mkOption {
              type = str;
              description = ''
                Desktop file within package to autostart.
              '';
            };

          }
        )

      );

      description = ''
        Custom management of autostart entries.
      '';

      example = lib.literalExpression ''
        [
          pkgs.firefox

          {
            package = pkgs.signal-desktop;
            filename = "signal.desktop";
          }
        ]
      '';

      default = [ ];

    };

  };

  config.xdg.autostart = {

    readOnly = true;

    entries = lib.mapAttrsToList

      (
        # Default behaviour assumes upstream does a good job packaging `x`.
        x: x.desktopEntry or "${x.package}/share/applications/${x.filename}"
      )

      config.xdg.autostart.my.entries;

  };


}
