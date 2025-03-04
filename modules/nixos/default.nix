{ config, inputs, lib, pkgs, ... }: {

  imports = with lib.fileset;

    [
      # Import essential external modules.
      inputs.home-manager.nixosModules.default
      inputs.sops-nix.nixosModules.default
    ]

    ++

    toList (difference
      # Automatically import all my NixOS modules.
      (fileFilter (file: file.hasExt "nix") ./.)
      ./default.nix # You cannot import yourself!
    )

  ;

  nix = {
    # We use flakes instead.
    channel.enable = false;

    gc = {
      automatic = true; dates = "weekly";
      options = "--delete-older-than 14d";
    };

    settings = {
      # Enable the experimental v3 CLI and flake support.
      experimental-features = [ "nix-command" "flakes" ];
    };
  };

  nixpkgs.config.allowUnfree = true;

  home-manager = {
    # Set Nixpkgs instance.
    useGlobalPkgs = true;

    # Access flake inputs in Home Manager.
    extraSpecialArgs = { inherit inputs; };

    # Move existing files out of the way.
    backupFileExtension = "backup";
  };

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

    # Secrets available to all hosts.
    secrets."nix-conf/gitlab-token" = { owner = "ewan"; };
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

  security = {
    acme = {
      acceptTerms = true;
      defaults = {
        email = "ewan@patchoulihq.cc"; dnsProvider = "cloudflare";
        environmentFile = config.sops.secrets."acme/cloudflare".path;
      };
    };

    polkit.enable = true;
    sudo.enable = true;
  };

  services = {
    openssh = {
      enable = true;
      settings = {
        # Force public-key authentication.
        PasswordAuthentication = false;
      };
    };

    locate = {
      enable = true; localuser = null;
      package = pkgs.plocate;
    };

    # Prefer MariaDB over MySQL.
    mysql.package = pkgs.mariadb;

    # Simple time synchronization.
    timesyncd.enable = lib.mkDefault true;
  };

  environment = {

    pathsToLink = [ "/share/zsh" ];

    systemPackages = with pkgs; [

      curl dig file findutils
      ffmpeg htop imagemagick
      lm_sensors lsd lsof ncdu
      neofetch nmap procps psmisc
      rsync sops unar usbutils
      wireguard-tools wget yt-dlp

    ];
  };
}
