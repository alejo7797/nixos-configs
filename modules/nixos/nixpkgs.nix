{ inputs, ... }: {

  nixpkgs = {

    config.allowUnfree = true;

    overlays = [

      # My personal derivations and scripts.
      inputs.my-expressions.overlays.default

      # We use rycee's addons flake directly.
      inputs.firefox-addons.overlays.default

      (
        # Backports.
        final: prev:

        let
          # Build a Nixpkgs instance based off of the `nixos-unstable` branch upstream.
          unstable = import inputs.nixpkgs-unstable { inherit (final) config system; };
        in

        {
          inherit (unstable)
          ;
        }
      )

    ];

  };
}
