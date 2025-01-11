{
  description = "My NixOS configurations.";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.11";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager/release-24.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    my-scripts = {
      url = "gitlab:alex/shell-scripts?host=git.patchoulihq.cc";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    flake-utils.url = "github:numtide/flake-utils";
    ilya-fedin.url = "github:ilya-fedin/nur-repository";
    impermanence.url = "github:nix-community/impermanence";
    nixgl.url = "github:nix-community/nixGL";
    nixvim.url = "github:nix-community/nixvim";
    nur.url = "github:nix-community/NUR";
    sops-nix.url = "github:Mic92/sops-nix";
    stylix.url = "github:danth/stylix";
  };

  outputs =
    {
      nixpkgs,
      home-manager,
      self,
      ...
    }@inputs:

    let
      mkSystem =
        config:
        nixpkgs.lib.nixosSystem {
          specialArgs = { inherit inputs self; };
          modules = [ config ] ++ [ self.nixosModules.default ];
        };

      mkHome =
        system: config:
        home-manager.lib.homeManagerConfiguration {
          pkgs = nixpkgs.legacyPackages.${system};
          extraSpecialArgs = { inherit inputs self; };
          modules = [ config ] ++ [ self.homeManagerModules.default ];
        };
    in

    {
      nixosConfigurations = {
        "qemu" = mkSystem hosts/qemu/configuration.nix;
        "shinobu" = mkSystem hosts/shinobu/configuration.nix;
      };

      homeConfigurations = {
        "ewan@satsuki" = mkHome "x86_64-linux" hosts/satsuki/configuration.nix;
      };

      nixosModules.default = modules/nixos;
      homeManagerModules.default = modules/home-manager;
    };

}
