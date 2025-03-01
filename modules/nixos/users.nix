{
  lib,
  self,
  config,
  pkgs,
  ...
}:

{
  options.myNixOS.home-users = lib.mkOption {

    description = "Attribute set containing user accounts.";

    type = with lib.types;
      attrsOf (submodule {
        options = {

          userConfig = lib.mkOption {
            description = "Home Manager configuration path.";
            type = path;
          };

          userSettings = lib.mkOption {
            description = "Settings for the NixOS users modules.";
            default = { };
          };
        };
      });

  };

  config = {

    home-manager.users = builtins.mapAttrs (

      _: user:

        { ... }:
        {
          imports = [
            # This is a complete config!
            self.homeManagerModules.default
            (import user.userConfig)
          ];
        }

    ) config.myNixOS.home-users;

    users.users = builtins.mapAttrs (

      _: user:

        lib.mkMerge [
          {
            shell = lib.mkOverride 100 pkgs.zsh;
            extraGroups = [ "networkmanager" "scanner" ];
            isNormalUser = true; linger = true;
          }
          user.userSettings
        ]

    ) config.myNixOS.home-users;

  };
}
