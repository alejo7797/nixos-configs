{ pkgs, lib, config, ... }: {

  options.myHome.xdgAutostart = lib.mkOption {
    type = lib.types.listOf lib.types.package;
    description = "List of programs to run at system startup.";
  };

  config = let

    stripVersion = with lib.strings; (packageName:
      builtins.elemAt (splitString "-" packageName) 0
    );

  in {

    xdg.configFile = builtins.listToAttrs (
      map
        (pkg: {
          name = "autostart/" + pkg.name + ".desktop";
          value = if pkg ? desktopItem then
            # We're happy.
            { text = pkg.desktopItem.text; }

          else { source = "${pkg}/share/applications/" + "${
            if pkg ? desktopFile then
              # We're confused.
              "${pkg.desktopFile}"

            else
              # We're mad.
              "${stripVersion pkg.name}.desktop"}";

          };

        })
        config.myHome.xdgAutostart
    );

  };
}
