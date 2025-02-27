{
  description = "My NixOS configurations";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.11";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager/release-24.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nur = {
      url = "github:nix-community/NUR";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    lanzaboote = {
      # Secure Boot support under NixOS.
      url = "github:nix-community/lanzaboote/v0.4.2";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    my-expressions = {
      # Personal derivations and overlays.
      url = "gitlab:alex/nix-expressions?host=git.patchoulihq.cc";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixvim = {
      # Configure Neovim declaratively.
      url = "github:nix-community/nixvim/nixos-24.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixos-mailserver = {
      # Convenient email server NixOS module.
      url = "gitlab:simple-nixos-mailserver/nixos-mailserver/nixos-24.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    ilya-fedin.url = "github:ilya-fedin/nur-repository";
    impermanence.url = "github:nix-community/impermanence";
    nix-minecraft.url = "github:Infinidoge/nix-minecraft";
    sops-nix.url = "github:Mic92/sops-nix/master";
    stylix.url = "github:danth/stylix/release-24.11";
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
        (hostname: _: mkSystem ./hosts/${hostname}/config.nix)
        (builtins.readDir ./hosts);

      # My master NixOS module for all systems.
      nixosModules = { default = ./modules/nixos; };

      # My master Home Manager module for all configurations.
      homeManagerModules = { default = ./modules/home-manager; };
    };

}
