{ pkgs, lib, config, ... }: {

  # Install and configure waybar.
  programs.waybar = {
    enable = true;
    systemd.enable = true;
  };

}
