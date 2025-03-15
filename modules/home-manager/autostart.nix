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

    (
      pkg:
        let
          name = pkg.pname or pkg.name;
        in
        {
          name = "autostart/${name}.desktop";
          value.source = "${pkg}/share/applications/${name}.desktop";
        }
    )

    config.my.autostart

  );
}
