{ inputs, pkgs, lib, config, ... }: {

  imports = [
    # External modules.
    inputs.home-manager.nixosModules.home-manager
    inputs.impermanence.nixosModules.impermanence
    inputs.sops-nix.nixosModules.sops
    inputs.nur.modules.nixos.default
    inputs.stylix.nixosModules.stylix

    # My personal modules.
    ./users.nix ./pam.nix ./locale.nix
    ./tuigreet.nix ./programs ./nvidia.nix
    ./wayland ./graphical.nix ./style.nix
  ];

  nix = {
    # Enable flakes support.
    settings.experimental-features = [ "nix-command" "flakes" ];

    # Disable channels.
    channel.enable = false;

    # Manage the system's flake registry.
    registry.nixpkgs.flake = inputs.nixpkgs;

    # And set NIX_PATH appropriately.
    nixPath = [ "nixpkgs=flake:nixpkgs" ];

    # Automatic garbage collection.
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 30d";
    };
  };


  # Allow unfree packages.
  nixpkgs.config.allowUnfree = true;

  # Configure nixpkgs overlays.
  nixpkgs.overlays = [

    # Access nixpkgs-unstable.
    (self: super: {
      unstable = import inputs.nixpkgs-unstable {
        inherit (super) system;
        config.allowUnfree = true;
      };
    })

    # Access ilya-fedin's repository.
    (self: super: {
      ilya-fedin = import inputs.ilya-fedin {
        pkgs = super;
      };
    })

  ];

  # Limit the number of generations to keep in the bootloader.
  boot.loader.systemd-boot.configurationLimit = 20;

  # Default networking configuration.
  networking = {

    # Use standard network interface names.
    usePredictableInterfaceNames = lib.mkDefault false;

    # Wireguard trips up rpfilter.
    firewall.checkReversePath = false;
  };

  # Enable OpenSSH.
  services.openssh = {
    enable = true;
    settings = {
      # Force public-key authentication.
      PasswordAuthentication = false;
    };
  };

  # Derive sops age key from host SSH key.
  sops.age.sshKeyPaths = [ "/etc/ssh/ssh_host_ed25519_key" ];
  sops.gnupg.sshKeyPaths = [ ];

  # Install and configure zsh.
  programs.zsh = {
    enable = true;
    autosuggestions.enable = true;
    syntaxHighlighting.enable = true;
  };

  # For zsh completion.
  environment.pathsToLink = [ "/share/zsh" ];

  # Install vim.
  myNixOS.vim.enable = true;

  # Install neovim.
  programs.neovim.enable = true;

  # Enable systemd-timesyncd.
  services.timesyncd.enable = lib.mkDefault true;

  # Enable polkit.
  security.polkit.enable = true;

  # Install Git.
  programs.git = {
    enable = true;
    package = pkgs.gitFull;
  };

  # Install direnv.
  programs.direnv.enable = true;

  # Install plocate.
  services.locate = {
    enable = true;
    localuser = null;
    package = pkgs.plocate;
  };

  # Install the following essential packages.
  environment.systemPackages = with pkgs; [
    curl dig file findutils
    ffmpeg htop imagemagick
    jq libfido2 lm_sensors
    lsd ncdu neofetch nettools
    nmap procps p7zip psmisc
    rsync sops unrar usbutils uv
    wireguard-tools wget yt-dlp
  ];
}
