{ inputs, pkgs, lib, config, ... }: {

  imports = [
    # My personal modules.
    ./zsh ./programs
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

    # Configure Zsh.
    myHome.zsh.enable = true;

    # Configure Neovim.
    myHome.neovim.enable = true;

    # Configure Git.
    myHome.git.enable = true;

    # Configure GnuPG.
    myHome.gpg.enable = true;

    # Add our personal scripts to PATH.
    home.sessionPath = [ "$HOME/.local/bin" ];

    # Link in our personal scripts.
    home.file.".local/bin" = {
      source = ./scripts;
      recursive = true;
    };
  };
}
