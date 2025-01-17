{
  inputs,
  ...
}:

let
  unstable = system:
    import inputs.nixpkgs-unstable {
      config.allowUnfree = true;
      inherit system;
    };
in

{
  nixpkgs.overlays = [

    # Access my personal scripts.
    inputs.my-scripts.overlays.default

    # Access packages from nixpkgs-unstable.
    (_: prev: {
      inherit (unstable prev.system)
        bolt-launcher
        joplin-desktop
        lutris spotify
        ;
    })

    # Specify desktop file locations.
    (_: prev: {
      joplin-desktop = prev.joplin-desktop // {
        desktopFile = "@joplinapp-desktop.desktop";
      };
    })

  ];
}
