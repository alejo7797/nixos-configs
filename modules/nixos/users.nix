{ inputs, outputs, pkgs, lib, myLib, config, ... }:

with lib;

{

  options.myNixOS.home-users = mkOption {
    description = "Attribute set containing user accounts.";
    type = with types; attrsOf (submodule {
      options = {

        userConfig = mkOption {
          description = "Home Manager configuration path.";
          type = path;
        };

        userSettings = mkOption {
          description = "Settings for the NixOS users module.";
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
      extraSpecialArgs = { inherit inputs outputs myLib; };
      users = builtins.mapAttrs ( name: user:

        { ... }: {
          imports = [
            outputs.homeManagerModules.default
            (import user.userConfig)
          ];
        }

      ) config.myNixOS.home-users;
    };

    # And define the user accounts themselves.
    users.users = builtins.mapAttrs (name: user: {

      # Sane defaults.
      isNormalUser = true;
      linger = true;
      shell = pkgs.zsh;
      extraGroups = [
        "networkmanager"
        "scanner" "wheel"
      ];

    } // user.userSettings

    ) (config.myNixOS.home-users);
  };
}
