{ config, inputs, lib, pkgs, self, ... }: {

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
      options = "--delete-older-than 7d";
    };

    settings = {
      # Enable the experimental v3 CLI and flake support.
      experimental-features = [ "nix-command" "flakes" ];

      # Use $XDG_STATE_HOME and so on.
      use-xdg-base-directories = true;
    };

  };

  home-manager = {

    # Get old files out of the way.
    backupFileExtension = "backup";

    # Access flake inputs in Home Manager.
    extraSpecialArgs = { inherit inputs; };

    sharedModules = [
      # Top-level module to build on.
      self.homeManagerModules.default
    ];

    # Check the documentation for what these do.
    useGlobalPkgs = true; useUserPackages = true;

  };

  sops = {

    # Keep each host's secrets their own suitably encrypted YAML file.
    defaultSopsFile = ../../secrets/${config.networking.hostName}.yaml;

    # We skip RSA host keys.
    gnupg.sshKeyPaths = [ ];

  };

  networking.firewall = {

    # Issues using Wireguard.
    checkReversePath = false;

    # Prevent dmesg from being flooded.
    logRefusedConnections = false;

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

    # Prefer MariaDB over MySQL.
    mysql.package = pkgs.mariadb;

    # Simple time synchronization.
    timesyncd.enable = lib.mkDefault true;

  };
}
