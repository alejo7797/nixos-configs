{ config, inputs, lib, ... }: {

  imports = with lib.fileset;

    [
      inputs.nixvim.homeManagerModules.nixvim
      inputs.sops-nix.homeManagerModules.sops
    ]

    # Recursively import all of my personal Home Manager modules.
    ++ toList (difference (fileFilter (file: file.hasExt "nix") ./.) ./default.nix);

  options = {
    myHome.lib = lib.mkOption {
      description = "Internal configuration utilities.";
      type = with lib.types; attrsOf anything;
    };
  };

  config = {

    nix = {
      enable = true;

      settings.use-xdg-base-directories = true;

      gc = {
        automatic = true; frequency = "daily";
        options = "--delete-older-than 7d";
      };
    };

    sops = {
      defaultSopsFile = ../../secrets/${config.home.username}.yaml;
      age.keyFile = "${config.xdg.configHome}/sops/age/keys.txt";
    };

    myHome = {
      git.enable = true;
      neovim.enable = true;
    };

    programs = {
      home-manager.enable = true;
    };

    xdg = {
      enable = true;

      configFile."nix/nix.conf".enable = false;
    };

    home.stateVersion = "24.11";
  };
}
