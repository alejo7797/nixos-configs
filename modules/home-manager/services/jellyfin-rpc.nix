{ config, lib, pkgs, ... }:

let
  cfg = config.services.my.jellyfin-rpc;

  json = pkgs.formats.json { };

  configFile = json.generate "main.json" cfg.settings;

  jellyfin-rpc = pkgs.writeShellScriptBin "jellyfin-rpc-wrapped" ''
    ${lib.getExe pkgs.jq} -s '.[0] * .[1]' ${configFile} ${cfg.secretsFile} |\
      ${lib.getExe pkgs.jellyfin-rpc} -c /dev/stdin
  '';
in

{
  options.services.my.jellyfin-rpc = {

    enable = lib.mkEnableOption "Jellyfin Discord rich presence";

    settings = lib.mkOption {
      type = with lib.types; submodule {
        options = {
          jellyfin = {
            url = lib.mkOption { type = str; };
            username = lib.mkOption { type = listOf str; };
            music.display = lib.mkOption {
              type = listOf str;
              default = [ "year" "album" ];
            };
          };
          discord = {
            buttons = lib.mkOption {
              type = nullOr (listOf (attrsOf str));
              default = null;
            };
          };
          images = {
            enable_images = lib.mkOption {
              type = bool; default = true;
            };
          };
        };
      };
      default = { };
    };

    secretsFile = lib.mkOption {
      type = with lib.types; nullOr path;
      default = null;
    };

  };

  config = lib.mkIf cfg.enable {

    systemd.user.services.jellyfin-rpc = {

      Unit = {
        Description = "Jellyfin Discord rich presence client";
        PartOf = [ "graphical-session.target" ];
        After = [ "graphical-session.target" ];
      };

      Service = {
        ExecStart = lib.getExe jellyfin-rpc;
        Restart = "on-failure";
      };

      Install.WantedBy = [ "graphical-session.target" ];

    };

  };
}
