{ config, lib, pkgs, ... }:

let
  cfg = config.xdg.autostart;

  linkedDesktopEntries = pkgs.runCommandLocal "xdg-autostart-entries" { } ''
    mkdir -p $out
    ${lib.concatMapStringsSep "\n" (e: "ln -s ${e} $out") cfg.entries}
  '';
in

{
  options.xdg.autostart = {
    enable = lib.mkEnableOption "creation of XDG autostart entries";

    entries = lib.mkOption {
      type = with lib.types; listOf path;
      description = ''
    Paths to desktop files that should be linked to `XDG_CONFIG_HOME/autostart`
      '';
      default = [ ];
    };

    my.entries = lib.mkOption {
      type = with lib.types; attrsOf str;
      description = "Desktop files to autostart.";
      default = { };
    };
  };

  config = lib.mkMerge [

    (
      lib.mkIf (cfg.enable && cfg.entries != [ ]) {
        xdg.configFile.autostart = {
          source = linkedDesktopEntries;
          recursive = false;
        };
      }
    )

    {
      xdg.autostart = {
        # TODO: add with 25.05
        # readOnly = true;

        entries = lib.mapAttrsToList (
          # TODO: make this a little smarter? There are limits...
          name: entry: "${pkgs.${name}}/share/applications/${entry}"
        ) config.xdg.autostart.my.entries;
      };
    }

  ];
}
