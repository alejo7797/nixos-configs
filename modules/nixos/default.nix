{
  inputs,
  config,
  pkgs,
  ...
}:

{
  imports = [
    inputs.home-manager.nixosModules.home-manager
    inputs.impermanence.nixosModules.impermanence
    inputs.lanzaboote.nixosModules.lanzaboote
    inputs.nur.modules.nixos.default
    inputs.sops-nix.nixosModules.sops
    inputs.stylix.nixosModules.stylix

    ./graphical ./locale.nix ./pam.nix
    ./programs ./overlays.nix ./services
    ./style.nix ./users.nix ./wayland
  ];

  nix = {
    channel.enable = false;

    # Smart Gitlab token secret management.
    extraOptions = "!include ${config.sops.secrets."nix-conf/gitlab-token".path}";

    gc = {
      automatic = true; dates = "weekly";
      options = "--delete-older-than 30d";
    };

    settings = {
      experimental-features = [ "nix-command" "flakes" ];
    };
  };

  nixpkgs.config.allowUnfree = true;

  boot.consoleLogLevel = 3;

  networking = {
    # Use standard network interface names.
    usePredictableInterfaceNames = false;

    firewall = {
      # Wireguard trips up rpfilter.
      checkReversePath = false;

      # Prevent dmesg spam.
      logRefusedConnections = false;
    };
  };

  sops = {
    # Default secrets file per host.
    defaultSopsFile = ../../secrets/${config.networking.hostName}.yaml;

    # Derive sops age key from host SSH key.
    age.sshKeyPaths = [ "/etc/ssh/ssh_host_ed25519_key" ];
    gnupg.sshKeyPaths = [ ];
  };

  programs = {
    zsh = {
      enable = true;
      autosuggestions.enable = true;
      syntaxHighlighting.enable = true;
    };

    git = {
      enable = true;
      package = pkgs.gitFull;
    };

    vim = {
      enable = true;
      defaultEditor = true;
    };
  };

  # For zsh shell completion.
  environment.pathsToLink = [ "/share/zsh" ];

  security.polkit.enable = true;

  services = {
    openssh = {
      enable = true;
      settings = {
        # Force public-key authentication.
        PasswordAuthentication = false;
      };
    };

    locate = {
      enable = true;
      localuser = null;
      package = pkgs.plocate;
    };

    timesyncd.enable = true;
  };

  environment.systemPackages = with pkgs; [

    curl dig file findutils
    ffmpeg htop imagemagick
    lm_sensors lsd lsof ncdu
    neofetch nmap procps psmisc
    rsync sops unar usbutils
    wireguard-tools wget yt-dlp

  ];
}
