{ pkgs, lib, config, ... }: {

  imports = [

    # My personal modules.
    ./zsh ./programs ./scripts
    ./autostart.nix ./style ./i3.nix
    ./graphical.nix ./wayland

  ];

  options.myHome = {

    hostname = lib.mkOption {
      description = "The system hostname.";
      example = "satsuki";
    };

    laptop.enable = lib.mkEnableOption "laptop configuration";

  };

  config = {

    # Allow unfree packages.
    nixpkgs.config.allowUnfree = true;

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

  };
}
