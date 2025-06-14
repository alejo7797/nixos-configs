{
  description = "Alex's NixOS configurations";

  inputs = {

    # Follow the latest stable NixOS release branch.
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.05";

    # Access newer versions of packages before the next release.
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager = {
      # Manage users' home environment configuration with Nix.
      url = "github:nix-community/home-manager/release-25.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-index-database = {
      # Helpful add-on to the nix-index location tool.
      url = "github:nix-community/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    lanzaboote = {
      # Enable Secure Boot support for NixOS systems.
      url = "github:nix-community/lanzaboote/v0.4.2";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    my-expressions = {
      # My personal scripts and Nix derivations.
      url = "github:alejo7797/nix-expressions";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixvim = {
      # Manage your Neovim config and LSPs using Nix.
      url = "github:nix-community/nixvim/nixos-25.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    firefox-addons = {
      # Get accesss to rycee's helpful list of browser extensions.
      url = "gitlab:rycee/nur-expressions?dir=pkgs/firefox-addons";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    autofirma-nix = {
      # Interact with Spain's public administration.
      url = "github:nix-community/autofirma-nix/main";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixos-mailserver = {
      # NixOS module setting up a complete but simple 10/10 email server.
      url = "gitlab:simple-nixos-mailserver/nixos-mailserver/nixos-25.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Set up an manage a modded Minecraf server on NixOS.
    nix-minecraft.url = "github:Infinidoge/nix-minecraft";

    # Cool theming framework for NixOS and Home Manager host.
    stylix.url = "github:nix-community/stylix/release-25.05";

    # Secret management tool for NixOS using sops.
    sops-nix.url = "github:Mic92/sops-nix/master";

  };

  outputs = { nixpkgs, self, ... }@inputs:

    let
      mkSystem = config: nixpkgs.lib.nixosSystem {
        modules = [ config self.nixosModules.default ];
        specialArgs = { inherit inputs self; };
      };
    in

    {
      nixosConfigurations = builtins.mapAttrs
        # Build a NixOS configuration for each machine sitting under ./hosts.
        (hostName: _: mkSystem ./hosts/${hostName}) (builtins.readDir ./hosts);

      nixosModules = {
        # Default top-level module.
        default = ./modules/nixos;

        # Personal configurations.
        users.ewan = ./users/ewan;
      };

      homeManagerModules = {
        # Top-level Home Manager module.
        default = ./modules/home-manager;

        # Personal Home Manager settings.
        users.ewan = ./users/ewan/home.nix;
      };
    };

}
