{ inputs, ... }: {

  nixpkgs = {

    config.allowUnfree = true;

    overlays = [

      # My personal derivations and scripts.
      inputs.my-expressions.overlays.default

      # The Nix User Repository.
      inputs.nur.overlays.default

      # Backports.
      (final: prev:

        let
          # Build a Nixpkgs instance based off of the `nixos-unstable` branch upstream.
          unstable = import inputs.nixpkgs-unstable { inherit (final) config system; };
        in

        {
          inherit (unstable)
            borgmatic # Don't use ~/.borgmatic.
            php # Fix some temporary php-cs issue?
            uwsm # Use login shell environment.
          ;

          # Upstream refactor.
          libgbm = final.mesa;

          # Alternative RuneScape launcher with support for Jagex account logins.
          bolt-launcher = unstable.bolt-launcher.override { inherit (final) libgbm; };

          # Enable Wayland IME, fix application icon, build against the correct mesa version.
          joplin-desktop = unstable.joplin-desktop.override { inherit (final) appimageTools; };
          signal-desktop = unstable.signal-desktop.override { inherit (final) callPackage; };

          # Enable Wayland IME, build against the correct mesa version.
          spotify = unstable.spotify.override { inherit (final) libgbm; };

          vimPlugins = prev.vimPlugins.extend (
            # Replace legacy maxlinenr symbol U+2630 with U+2261.
            _: _: { inherit (unstable.vimPlugins) vim-airline; }
          );
        }

      )

    ];

  };
}
