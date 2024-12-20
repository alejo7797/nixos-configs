{ pkgs, lib, config, ... }: {

  home.username = "ewan";
  home.homeDirectory = "/home/ewan";
  home.stateVersion = "24.11";

  # Load up our custom theme.
  myHome.style.enable = true;

  # Configure some basic graphical utilities.
  myHome.graphical-environment = true;

  # Temporary stop-gap.
  services.gammastep.settings.general = {
    adjustment-method = "wayland";
  };

  # Configure zsh.
  programs.zsh = {

    # Host-specific aliases.
    shellAliases = let
      what-is-my-ip = "${pkgs.dig}/bin/dig +short myip.opendns.com";
    in {

        # Legacy dotfiles implementation.
        dotfiles = "${pkgs.git}/bin/git --git-dir=$HOME/.dotfiles --work-tree=$HOME";

        # Relies on a custom firewall rule.
        pubip = "${what-is-my-ip} @resolver1.opendns.com";
        vpnip = "${what-is-my-ip} @resolver2.opendns.com";

        # Manage the wonderful toolchain.
        wf-pacman = "sudo -u wonderful /opt/wonderful/bin/wf-pacman";

    };

    # Host specific plugins.
    oh-my-zsh.plugins = [ "archlinux" ];

    plugins = [
      {
        name = "nix-zsh-completions";
        src = "${pkgs.nix-zsh-completions}/share/zsh/plugins/nix";
      }
      {
        name = "zsh-autosuggestions";
        src = pkgs.fetchFromGitHub {
          owner = "zsh-users";
          repo = "zsh-autosuggestions";
          rev = "0.7.1";
          sha256 = "sha256-iJdWopZwHpSyYl5/FQXEW7gl/SrKaYDEtTH9cGP7iPo=";
        };
      }
    ];

  };

  # Install packages to our user profile.
  home.packages = with pkgs; [
    nixfmt-rfc-style
    nixos-generators
    nixgl.auto.nixGLDefault
  ];

}
