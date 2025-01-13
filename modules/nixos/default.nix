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
    inputs.sops-nix.nixosModules.sops
    inputs.stylix.nixosModules.stylix
    inputs.nur.modules.nixos.default

    ./graphical
    ./programs
    ./wayland

    ./locale.nix
    ./pam.nix
    ./style.nix
    ./users.nix
  ];

  nix = {
    settings = {
      experimental-features = [
        "nix-command"
        "flakes"
      ];
    };

    channel.enable = false;

    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 30d";
    };
  };

  nixpkgs = {
    config.allowUnfree = true;

    overlays = [
      # Access nixpkgs-unstable.
      (_: prev: {
        unstable = import inputs.nixpkgs-unstable {
          inherit (prev) system;
          config.allowUnfree = true;
        };
      })

      # Access my personal scripts.
      inputs.my-scripts.overlays.default
    ];
  };

  boot = {
    consoleLogLevel = 3;
    loader = {
      systemd-boot = {
        enable = true;
        editor = false;
      };
    };
  };

  networking = {
    # Use standard network interface names.
    usePredictableInterfaceNames = false;

    # Wireguard trips up rpfilter.
    firewall.checkReversePath = false;
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

    direnv.enable = true;
  };

  # For zsh completion.
  environment.pathsToLink = [ "/share/zsh" ];

  myNixOS.vim.enable = true;

  security.polkit.enable = true;

  services = {
    openssh = {
      enable = true;
      settings = {
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

    curl dig file
    findutils ffmpeg
    htop imagemagick
    lm_sensors lsd ncdu
    neofetch nettools
    nixos-generators
    nmap procps p7zip
    psmisc rsync sops
    unrar usbutils uv
    wireguard-tools
    wget yt-dlp

  ];
}
