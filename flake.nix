{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.11";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager/release-24.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nvf = {
      url = "github:notashelf/nvf";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    ilya-fedin.url = "github:ilya-fedin/nur-repository";
    impermanence.url = "github:nix-community/impermanence";
    nixgl.url = "github:nix-community/nixGL";
    nur.url = "github:nix-community/NUR";
    sops-nix.url = "github:Mic92/sops-nix";
    stylix.url = "github:danth/stylix";
  };

  outputs =
    { ... }@inputs:

    let
      myLib = import ./my-lib.nix { inherit inputs; };
    in

    with myLib;

    {
      nixosConfigurations = {
        "nixos-vm" = mkSystem ./hosts/nixos-vm/configuration.nix;
        "shinobu" = mkSystem ./hosts/shinobu/configuration.nix;
      };

      homeConfigurations = {
        "ewan@satsuki" = mkHome "x86_64-linux" ./hosts/satsuki/home.nix;
      };

      nixosModules.default = ./modules/nixos;
      homeManagerModules.default = ./modules/home-manager;
    };

}
