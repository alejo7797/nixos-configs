{
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
    nixgl.url = "github:nix-community/nixGL";
    stylix.url = "github:danth/stylix";
    ilya-fedin.url = "github:ilya-fedin/nur-repository";
  };

  outputs = { ... }@inputs: let

    myLib = import ./my-lib.nix { inherit inputs; };

  in with myLib; {

    nixosConfigurations = {
      "nixos-vm" = mkSystem ./hosts/nixos-vm/configuration.nix;
      "shinobu" = mkSystem ./hosts/shinobu/configuration.nix;
    };

    homeConfigurations = {
      "ewan@shinobu" = mkHome "x86_64-linux" ./hosts/shinobu/home.nix;
      "ewan@satsuki" = mkHome "x86_64-linux" ./hosts/satsuki/home.nix;
    };

    nixosModules.default = ./modules/nixos;
    homeManagerModules.default = ./modules/home-manager;

  };
}
