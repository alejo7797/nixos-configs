{
  lib,
  config,
  ...
}:

{
  options.my.autostart = lib.mkOption {
    type = with lib.types; listOf package;
    description = "List of programs to autostart with the user session.";
    default = [ ];
  };

  config.xdg.configFile = builtins.listToAttrs (map

    (pkg: {
      name = "autostart/${pkg.name}.desktop";
      value = { inherit (pkg.desktopItem) text; };
    })

    config.my.autostart

  );
}
