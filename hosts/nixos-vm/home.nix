{ pkgs, lib, config, ... }: {


  # Set the system hostname.
  myHome.hostname = "nixos-vm";

  # Basic settings needed by Home Manager.
  home.username = "ewan";
  home.homeDirectory = "/home/ewan";
  home.stateVersion = "24.11";

  # Load up our custom theme.
  myHome.style.enable = true;

  # Set up sway, the i3-compatible Wayland compositor.
  myHome.sway.enable = true;

}
