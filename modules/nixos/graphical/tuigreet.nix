{
  lib,
  config,
  pkgs,
  ...
}:

let
  cfg = config.myNixOS.tuigreet;
in

{
  options.myNixOS.tuigreet = {
    enable = lib.mkEnableOption "tuigreet";

    autologin = {
      enable = lib.mkEnableOption "autologin";

      command = lib.mkOption {
        type = lib.types.str;
        description = "Initial session for autologin.";
        default = "${pkgs.uwsm}/bin/uwsm start -S -F /run/current-system/sw/bin/Hyprland";
      };

      user = lib.mkOption {
        type = lib.types.str;
        description = "User to enable autologin for.";
      };
    };
  };

  config = lib.mkIf cfg.enable {

    services.greetd = {
      enable = true;
      settings = {

        default_session = {
          command = "${pkgs.greetd.tuigreet}/bin/tuigreet --remember --remember-session";
          user = "greeter";
        };

        initial_session = lib.mkIf cfg.autologin.enable {
          inherit (cfg.autologin) command user;
        };
      };
    };
  };
}
