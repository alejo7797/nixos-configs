{
  description = "My NixOS configurations.";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.11";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager/release-24.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixvim = {
      url = "github:nix-community/nixvim";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };

    my-scripts = {
      url = "gitlab:alex/shell-scripts?host=git.patchoulihq.cc";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    lanzaboote = {
      url = "github:nix-community/lanzaboote/v0.4.1";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nur = {
      url = "github:nix-community/NUR";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    flake-utils.url = "github:numtide/flake-utils";
    ilya-fedin.url = "github:ilya-fedin/nur-repository";
    impermanence.url = "github:nix-community/impermanence";
    nixgl.url = "github:nix-community/nixGL";
    sops-nix.url = "github:Mic92/sops-nix";
    stylix.url = "github:danth/stylix/release-24.11";
  };

  outputs =
    { nixpkgs, self, ... }@inputs:

    let
      mkSystem =
        config:
        nixpkgs.lib.nixosSystem {
          specialArgs = { inherit inputs self; };
          modules = [ config self.nixosModules.default ];
        };
    in

    {
      nixosConfigurations = {
        "qemu-vm" = mkSystem hosts/qemu-vm/configuration.nix;
        "satsuki" = mkSystem hosts/satsuki/configuration.nix;
        "shinobu" = mkSystem hosts/shinobu/configuration.nix;
      };

      nixosModules.default = modules/nixos;
      homeManagerModules.default = modules/home-manager;
    };

}
