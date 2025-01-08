{ inputs, config, ... }:

{
  imports = [
    # External modules.
    inputs.nixvim.homeManagerModules.nixvim
    inputs.nur.modules.homeManager.default
    inputs.sops-nix.homeManagerModules.sops

    # My personal modules.
    ./zsh
    ./programs
    ./graphical.nix
    ./arch-linux.nix
  ];

  config = {
    # Automatic garbage collection.
    nix.gc = {
      automatic = true;
      frequency = "weekly";
      options = "--delete-older-than 7d";
    };

    # Let Home Manager install and manage itself.
    programs.home-manager.enable = true;

    sops = {
      # Default sops file for user secrets.
      defaultSopsFile = ../../secrets/${config.home.username}.yaml;

      # Specify path where age key is kept.
      age.keyFile = "${config.xdg.configHome}/sops/age/keys.txt";
    };

    myHome = {
      # Configure Zsh.
      zsh.enable = true;

      # Configure NeoVim.
      neovim.enable = true;

      # Configure Git.
      git.enable = true;

      # Configure GnuPG.
      gpg.enable = true;
    };

    # Add our personal scripts to PATH.
    home.sessionPath = [ "$HOME/.local/bin" ];

    # Link in our personal scripts.
    home.file.".local/bin" = {
      source = ./scripts;
      recursive = true;
    };
  };
}
