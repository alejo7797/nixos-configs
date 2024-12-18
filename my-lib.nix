{ inputs }: let
  myLib = (import ./my-lib.nix) { inherit inputs; };
  outputs = inputs.self.outputs;
in rec {

  # Return the appropriate Nixpkgs instance.
  pkgsFor = system:
    import inputs.nixpkgs {
      inherit system;
      overlays = [
        inputs.nixgl.overlay
        inputs.nur.overlays.default
      ];
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

  # Set an attribute across each of GTK2/3/4.
  gtkExtra = a: v: {
    gtk2.extraConfig = "${a} = ${v}";
    gtk3.extraConfig.${a} = "${v}";
    gtk4.extraConfig.${a} = "${v}";
  };

}
