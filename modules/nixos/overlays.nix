{
  inputs,
  ...
}:

{
  nixpkgs.overlays = [

    # Access my personal scripts.
    inputs.my-scripts.overlays.default

    # Access packages from nixpkgs-unstable.
    (_: prev:
      let
        unstable = import inputs.nixpkgs-unstable {
          inherit (prev) system;
          config.allowUnfree = true;
        };
      in
      {
        inherit (unstable)
          bolt-launcher lutris spotify;
      }
    )

    # Specify desktop file locations.
    (_: prev: {
      joplin-desktop = prev.joplin-desktop // {
        desktopFile = "@joplinapp-desktop.desktop";
      };
    })

  ];
}
