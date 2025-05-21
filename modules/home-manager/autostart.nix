{ config, lib, pkgs, ... }: {

  options.xdg.autostart = {
    my.entries = lib.mkOption {
      type = with lib.types; attrsOf str;
      description = "Desktop files to autostart.";
      default = { };
    };
  };

  config =  {

    xdg.autostart = {
      readOnly = true;

      entries = lib.mapAttrsToList (
        # TODO: make this a little smarter? There are limits...
        name: entry: "${pkgs.${name}}/share/applications/${entry}"
      ) config.xdg.autostart.my.entries;
    };

  };

}
