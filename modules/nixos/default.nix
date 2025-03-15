{ config, inputs, lib, self, ... }: {

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

    # Take note of these!
    useUserPackages = true;
    useGlobalPkgs = true;

  };

  sops = {

    # Encrypted using the host's ed25519 public SSH key, in age format.
    defaultSopsFile = ../../secrets/${config.networking.hostName}.yaml;

    # Skip loading any RSA SSH host keys.
    gnupg.sshKeyPaths = lib.mkDefault [ ];

  };
}
