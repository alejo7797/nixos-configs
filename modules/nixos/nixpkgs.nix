{ inputs, ... }: {

  nixpkgs = {

    config.allowUnfree = true;

    overlays = [

      # My personal derivations and scripts.
      inputs.my-expressions.overlays.default

      # The Nix User Repository.
      inputs.nur.overlays.default

      (
        # Backports.
        final: prev:

        let
          # Build a Nixpkgs instance based off of the `nixos-unstable` branch upstream.
          unstable = import inputs.nixpkgs-unstable { inherit (final) config system; };
        in

        {
          inherit (unstable)
            azahar # New 3DS emulator project.
            borgmatic # Don't use ~/.borgmatic.
            uwsm # Inherit shell environment.
          ;

          # Upstream refactor.
          libgbm = final.mesa;

          # Alternative RuneScape launcher with support for Jagex account logins.
          bolt-launcher = unstable.bolt-launcher.override { inherit (final) libgbm; };
          altus = unstable.altus.override { inherit (final) appimageTools; };

          # Enable Wayland IME, fix application icon and build with the correct mesa version.
          signal-desktop = unstable.signal-desktop-bin.override { inherit (final) callPackage; };
          joplin-desktop = unstable.joplin-desktop.override { inherit (final) appimageTools; };

          # Enable Wayland IME and build against the correct mesa version.
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
