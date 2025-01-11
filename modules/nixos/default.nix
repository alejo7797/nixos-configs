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

    ./users.nix
    ./pam.nix
    ./locale.nix
    ./tuigreet.nix
    ./programs
    ./nvidia.nix
    ./wayland
    ./graphical.nix
    ./style.nix
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

  # Use standard network interface names.
  networking.usePredictableInterfaceNames = false;

  # Wireguard trips up rpfilter.
  networking.firewall.checkReversePath = false;

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

  # Install vim.
  myNixOS.vim.enable = true;

  security.polkit.enable = true;

  services = {
    openssh = {
      enable = true;
      settings = {
        PasswordAuthentication = false;
      };
    };

    timesyncd.enable = true;

    # Install plocate.
    locate = {
      enable = true;
      localuser = null;
      package = pkgs.plocate;
    };
  };

  # Install the following essential packages.
  environment.systemPackages = with pkgs; [
    curl
    dig
    file
    findutils
    ffmpeg
    htop
    imagemagick
    jq
    libfido2
    lm_sensors
    lsd
    ncdu
    neofetch
    nettools
    nmap
    procps
    p7zip
    psmisc
    rsync
    sops
    unrar
    usbutils
    uv
    wireguard-tools
    wget
    yt-dlp
  ];
}
