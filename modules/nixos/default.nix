{
  lib,
  inputs,
  config,
  pkgs,
  ...
}:

{
  imports = with lib.fileset;

    [
      inputs.home-manager.nixosModules.home-manager
      inputs.impermanence.nixosModules.impermanence
      inputs.lanzaboote.nixosModules.lanzaboote
      inputs.nixos-mailserver.nixosModules.default
      inputs.nur.modules.nixos.default
      inputs.sops-nix.nixosModules.sops
      inputs.stylix.nixosModules.stylix
    ]

    # Recursively import all of my personal NixOS modules.
    ++ toList (difference (fileFilter (file: file.hasExt "nix") ./.) ./default.nix);

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
    timesyncd.enable = true;
  };

  environment = {
    # Zsh shell completion support.
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
