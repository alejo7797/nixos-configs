{ inputs, outputs, pkgs, lib, myLib, config, ... }: {

  options.myNixOS.home-users = lib.mkOption {
    description = "attribute set containing user accounts";
    type = lib.types.attrsOf (lib.types.submodule {
      options = {
        userConfig = lib.mkOption {
          description = "home-manager configuration file";
          default = ../hosts/satsuki/home.nix;
        };
        userSettings = lib.mkOption {
          description = "settings for the NixOS users module";
          default = {};
        };
      };
    });
  };

  config = {

    # Set up Home Manager given myNixOS.home-users.
    home-manager = {
      useGlobalPkgs = true;
      extraSpecialArgs = { inherit inputs outputs myLib; };
      users = builtins.mapAttrs (name: user: {...}: {
        imports = [
          outputs.homeManagerModules.default
          (import user.userConfig)
        ];
      }) (config.myNixOS.home-users);
    };

    # And define the user account itself.
    users.users = builtins.mapAttrs (name: user: {

      # Sane defaults.
      isNormalUser = true;
      initialPassword = "admin";
      description = "";
      shell = pkgs.zsh;
      extraGroups = ["networkmanager" "wheel"];

    # With customisation.
    } // user.userSettings

    ) (config.myNixOS.home-users);

  };

}
