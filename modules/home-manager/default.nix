{ inputs, myLib, ... }: {

  imports = [ ./zsh.nix ./style.nix ./gui.nix ./wayland ];

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  # Configure zsh.
  myHome.zsh.enable = true;

}
