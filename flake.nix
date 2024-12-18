{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.11";
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
    in
    with myLib;
    {

      nixosConfigurations = {
        "nixos-vm" = mkSystem ./hosts/nixos-vm/configuration.nix;
      };

      homeConfigurations = {
        "ewan@nixos-vm" = mkHome "x86_64-linux" ./hosts/nixos-vm/home.nix;
        "ewan@satsuki" = mkHome "x86_64-linux" ./hosts/satsuki/home.nix;
      };

      nixosModules.default = ./nixos-modules;
      homeManagerModules.default = ./home-manager-modules;

    };
}
