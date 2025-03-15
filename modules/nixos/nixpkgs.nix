{ inputs, ... }: {

  nixpkgs = {

    config.allowUnfree = true;

    overlays = [

      # My personal derivations and scripts.
      inputs.my-expressions.overlays.default

      # The Nix User Repository.
      inputs.nur.overlays.default

      (final: _:

        let
          # Build a Nixpkgs instance based off of the `nixos-unstable` branch upstream.
          unstable = import inputs.nixpkgs-unstable { inherit (final) config system; };
        in

        {
          inherit (unstable)
            borgmatic # Don't use ~/.borgmatic.
            joplin-desktop # Enable Wayland IME.
            uwsm # Use login shell environment.
          ;

          # Alternative RuneScape launcher with support for Jagex account logins.
          bolt-launcher = unstable.bolt-launcher.override { libgbm = final.mesa; };

          # Enable Wayland IME; build against the correct mesa version.
          spotify = unstable.spotify.override { libgbm = final.mesa; };
        }

      )

    ];

  };
}
