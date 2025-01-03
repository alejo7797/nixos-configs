{ pkgs, lib, config, ... }: {

  options.myHome.xdgAutostart = lib.mkOption {
    type = lib.types.listOf lib.types.package;
    description = "List of programs to run at system startup.";
    default = [ ];
  };

  config =

    let
      stripVersion = with lib.strings; (
        packageName:
          builtins.elemAt (splitString "-" packageName) 0
      );
    in

    {
      xdg.configFile = builtins.listToAttrs (

        map

          (
            pkg: {
              name = "autostart/" + pkg.name + ".desktop";
              value =
                let
                  desktopFile =
                    if pkg ? desktopFile then
                      pkg.desktopFile
                    else
                      "${stripVersion pkg.name}.desktop";
                in

                if pkg ? desktopItem then
                  { text = pkg.desktopItem.text; }
                else
                  { source = "${pkg}/share/applications/${desktopFile}"; };
            }
          )

          config.myHome.xdgAutostart

      );
    };

}
