{ inputs, outputs, pkgs, lib, myLib, config, ... }: {

  options.myNixOS.home-users = with lib.types;
    lib.mkOption {
      description = "Attribute set containing user accounts.";
      type = attrsOf (submodule {
        options = {

          userConfig = lib.mkOption {
            description = "Home Manager configuration path.";
            type = path;
          };

          userSettings = lib.mkOption {
            description = "Settings for the NixOS users module.";
            default = {};
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
