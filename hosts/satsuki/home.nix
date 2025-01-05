{ pkgs, lib, config, ... }: {

  # Arch Linux quirks.
  imports = [ ./arch-linux.nix ];

  # Basic settings needed by Home Manager.
  home.username = "ewan";
  home.homeDirectory = "/home/ewan";
  home.stateVersion = "24.11";

  # Load up our custom theme.
  myHome.style.enable = true;

  # Configure some basic graphical utilities.
  myHome.graphical.enable = true;

  # Configure zsh.
  programs.zsh = {

    # Host-specific aliases.
    shellAliases =
      let
        what-is-my-ip = "${pkgs.dig}/bin/dig +short myip.opendns.com";
      in {
        # Legacy dotfiles implementation.
        dotfiles = "${pkgs.git}/bin/git --git-dir=$HOME/.dotfiles --work-tree=$HOME";

        # These rely on a custom firewall rule.
        pubip = "${what-is-my-ip} @resolver1.opendns.com";
        vpnip = "${what-is-my-ip} @resolver2.opendns.com";

        # Manage the wonderful toolchain.
        wf-pacman = "sudo -u wonderful /opt/wonderful/bin/wf-pacman";
      };
  };

  # Install packages to the user profile.
  home.packages = with pkgs; [
    nixfmt-rfc-style
    nixos-generators
    nixgl.nixGLIntel
  ];

}
