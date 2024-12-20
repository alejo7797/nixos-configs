{ inputs, myLib, ... }: {

  imports = [

    # My personal modules.
    ./zsh.nix ./programs ./style.nix
    ./gui.nix ./wayland ./i3.nix

  ];

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  # Configure zsh.
  myHome.zsh.enable = true;

}
