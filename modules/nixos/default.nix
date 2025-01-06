{ inputs, pkgs, lib, config, ... }: {

  imports = [
    # External modules.
    inputs.home-manager.nixosModules.home-manager
    inputs.impermanence.nixosModules.impermanence
    inputs.sops-nix.nixosModules.sops
    inputs.stylix.nixosModules.stylix
    inputs.nur.modules.nixos.default

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

  # Default boot loader configuration.
  boot.loader = {

    # Use systemd-boot by default.
    systemd-boot = {
      enable = true;

      # Disable the command line editor.
      editor = false;

      # Limit the number of system configurations.
      configurationLimit = 20;
    };

    # Allow systemd-boot to modify EFI variables.
    efi.canTouchEfiVariables = true;
  };

  # Use standard network interface names.
  networking.usePredictableInterfaceNames = false;

  # Wireguard trips up rpfilter.
  networking.firewall.checkReversePath = false;

  # Enable OpenSSH.
  services.openssh = {
    enable = true;
    settings = {
      # Force public-key authentication.
      PasswordAuthentication = false;
    };
  };

  sops = {
    # Default secrets file per host.
    defaultSopsFile = ../../secrets/${config.networking.hostName}.yaml;

    # Derive sops age key from host SSH key.
    age.sshKeyPaths = [ "/etc/ssh/ssh_host_ed25519_key" ];
    gnupg.sshKeyPaths = [ ];
  };

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
  services.timesyncd.enable = true;

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
