{ inputs }:

let
  inherit (inputs.self) outputs;
  myLib = (import ./my-lib.nix) { inherit inputs; };
in

rec {
  # Return the appropriate Nixpkgs instance.
  pkgsFor = system:
    import inputs.nixpkgs {
      inherit system;
      overlays = [ inputs.nixgl.overlay ];
    };

  # Build a NixOS configuration.
  mkSystem = config:
    inputs.nixpkgs.lib.nixosSystem {
      specialArgs = { inherit inputs outputs myLib; };
      modules = [ config outputs.nixosModules.default ];
    };

  # Build a Home Manager configuration.
  mkHome = sys: config:
    inputs.home-manager.lib.homeManagerConfiguration {
      pkgs = pkgsFor sys;
      extraSpecialArgs = { inherit inputs outputs myLib; };
      modules = [ config outputs.homeManagerModules.default ]
        ++ [ inputs.stylix.homeManagerModules.stylix ];
    };

  # Build an attribute set with a common value.
  setListTo = value: list: builtins.listToAttrs (
    map (name: { inherit name value; }) list
  );

  # Set an attribute across each of GTK2/3/4.
  gtkExtra = name: value: {
    gtk2.extraConfig = "${name} = ${value}";
    gtk3.extraConfig.${name} = value;
    gtk4.extraConfig.${name} = value;
  };
}
