{ ... }: {

  imports = [

    # My personal modules.
    ./zsh ./programs ./style
    ./gui.nix ./wayland ./i3.nix

  ];

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  # Configure zsh.
  myHome.zsh.enable = true;

  # Configure neovim.
  myHome.neovim.enable = true;

  # Configure git.
  myHome.git.enable = true;

}
