{ lib, pkgs, ... }: {

  home.username = "ewan";
  home.homeDirectory = "/home/ewan";
  home.stateVersion = "24.11";

  # Load up our custom theme.
  myHome.style.enable = true;

  # Set up sway, the i3-compatible Wayland compositor.
  myHome.sway.enable = true;

  # Configure zsh.
  programs.zsh = {
    enable = true;
    history.save = 5000;
  };

  # Install and configure kitty.
  programs.kitty = {
    enable = true;
  };

}
