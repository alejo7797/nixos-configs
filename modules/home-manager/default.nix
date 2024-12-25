{ pkgs, lib, config, ... }: {

  imports = [

    # My personal modules.
    ./zsh ./programs ./scripts ./style
    ./gui.nix ./wayland ./i3.nix

  ];

  options.myHome = {

    hostname = lib.mkOption {
      description = "system hostname";
    };

    laptop.enable = lib.mkEnableOption "laptop configuration";

  };

  config = {

    # Allow unfree packages.
    nixpkgs.config.allowUnfree = true;

    # Let Home Manager install and manage itself.
    programs.home-manager.enable = true;

    # Configure zsh.
    myHome.zsh.enable = true;

    # Configure neovim.
    myHome.neovim.enable = true;

    # Configure git.
    myHome.git.enable = true;

  };
}
