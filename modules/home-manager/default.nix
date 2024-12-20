{ inputs, ... }: {

  imports = [

    # My personal Home Manager modules.
    ./style.nix ./sway.nix ./hyprland.nix
    ./zsh.nix ./gui.nix ./wayland.nix

  ];

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  # Configure zsh.
  myHome.zsh.enable = true;

}
