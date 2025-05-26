{ config, lib, ... }: {

  options.xdg.autostart = {

    my.entries = lib.mkOption {

      type = with lib.types; listOf (

        # Simple case.
        either package

        (
          submodule {

            options = {

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

    entries = map

      (
        x:
          # Manual override for packages who don't do things as we desire.
          if x ? filename then "${x.package}/share/applications/${x.filename}"

          else (

            let
              # Our relatively simple desktop entry derivation fetcher.
              deskItem = x.desktopItem or (builtins.head x.desktopItems);
            in

              # The deskItem derivation wraps the actual entry.
              "${deskItem}/share/applications/${deskItem.name}"

          )
      )

      config.xdg.autostart.my.entries;

  };


}
