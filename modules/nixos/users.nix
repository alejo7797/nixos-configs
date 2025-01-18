{
  lib,
  self,
  inputs,
  config,
  pkgs,
  ...
}:

{
  options.myNixOS.home-users = lib.mkOption {
    description = "Attribute set containing user accounts.";
    type =
      with lib.types;
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

    # Set up Home Manager given myNixOS.home-users.
    home-manager = {
      useGlobalPkgs = true;
      backupFileExtension = "backup";
      extraSpecialArgs = { inherit inputs; };
      users = builtins.mapAttrs (
        _: user:

        { ... }:
        {
          imports = [
            self.homeManagerModules.default
            (import user.userConfig)
          ];
        }

      ) config.myNixOS.home-users;
    };

    # And define the user accounts themselves.
    users.users = builtins.mapAttrs (
      _: user:

      {
        # Sane defaults.
        isNormalUser = true;
        linger = true;
        shell = pkgs.zsh;
        extraGroups = [
          "networkmanager"
          "scanner" "wheel"
        ];
      }
      // user.userSettings

    ) config.myNixOS.home-users;
  };
}
