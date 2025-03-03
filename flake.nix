{
  description = "Alex's NixOS configurations";

  inputs = {

    # Follow the latest stable NixOS release branch.
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.11";

    # Access newer versions of packages before a new release.
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager = {
      # Manage a user's home environment using Nix.
      url = "github:nix-community/home-manager/release-24.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nur = {
      url = "github:nix-community/NUR";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    lanzaboote = {
      # Secure Boot support for NixOS systems.
      url = "github:nix-community/lanzaboote/v0.4.2";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    my-expressions = {
      # My personal Nix derivations and Nixpkgs overlays.
      url = "gitlab:alex/nix-expressions?host=git.patchoulihq.cc";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixvim = {
      # A Neovim configuration system for Nix.
      url = "github:nix-community/nixvim/nixos-24.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixos-mailserver = {
      # NixOS module for easily setting up an email server.
      url = "gitlab:simple-nixos-mailserver/nixos-mailserver/nixos-24.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    stylix.url = "github:danth/stylix/release-24.11";
    impermanence.url = "github:nix-community/impermanence";
    nix-minecraft.url = "github:Infinidoge/nix-minecraft";
    sops-nix.url = "github:Mic92/sops-nix/master";

  };

  outputs = { nixpkgs, self, ... }@inputs:

    let
      mkSystem = config: nixpkgs.lib.nixosSystem {
        specialArgs = { inherit inputs self; };
        modules = [ config self.nixosModules.default ];
      };
    in

    {
      nixosConfigurations = builtins.mapAttrs
        (hostName: _: mkSystem ./hosts/${hostName})
        (builtins.readDir ./hosts);

      # Top-level NixOS module for all hosts.
      nixosModules.default = ./modules/nixos;

      # Top-level module for all home user configurations.
      homeManagerModules.default = ./modules/home-manager;
    };

}
