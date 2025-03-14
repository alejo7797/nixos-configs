{ inputs, ... }: {

  nixpkgs = {

    config.allowUnfree = true;

    overlays = [

      inputs.my-expressions.overlays.default
      inputs.nix-minecraft.overlays.default
      inputs.nur.overlays.default

      (final: _: {
        bolt-launcher = final.callPackage (import "${inputs.nixpkgs-unstable}/pkgs/by-name/bo/bolt-launcher/package.nix") { libgbm = final.mesa; };
        borgmatic = final.callPackage (import "${inputs.nixpkgs-unstable}/pkgs/by-name/bo/borgmatic/package.nix") { };
        joplin-desktop = final.callPackage (import "${inputs.nixpkgs-unstable}/pkgs/by-name/jo/joplin-desktop/package.nix") { };
        spotify = final.callPackage (import "${inputs.nixpkgs-unstable}/pkgs/by-name/sp/spotify/package.nix") { libgbm = final.mesa; };
        uwsm = final.callPackage (import "${inputs.nixpkgs-unstable}/pkgs/by-name/uw/uwsm/package.nix") { };
      })

    ];

  };
}
