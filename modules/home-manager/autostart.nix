{ pkgs, lib, config, ... }: {

  options.myHome.xdgAutostart = lib.mkOption {
    type = lib.types.listOf lib.types.package;
    description = "List of programs to run at system startup.";
  };

  config = {

    xdg.configFile = builtins.listToAttrs (
      map
        (pkg: {
          name = pkg.name + ".desktop";
          value = if pkg ? desktopItem then
            { text = pkg.desktopItem.text; }
          else
            { source = "${pkg}/share/applications/${pkg.desktopFile}"; };
        })
        config.myHome.xdgAutostart
    );

  };
}
