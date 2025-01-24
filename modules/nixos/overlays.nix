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

    # Access my personal packages.
    inputs.my-expressions.overlays.default

    # Access packages from nixpkgs-unstable.
    (_: prev: {
      inherit (unstable prev.system)
        bolt-launcher
        joplin-desktop
        lutris spotify
        ;
    })

    # Access the SnapPy python module in Sage.
    (_: prev: {
      sage = prev.sage.override {
        extraPythonPackages = ps: with ps; [ snappy ];
        requireSageTests = false;
      };
    })

    # Add extra libraries to Lutris.
    (_: prev: {
      lutris = prev.lutris.override {
        extraLibraries = pkgs: with pkgs;
          [ libgudev libvdpau speex ];
      };
    })

    # Specify desktop file locations.
    (_: prev: {
      joplin-desktop = prev.joplin-desktop // {
        desktopFile = "@joplinapp-desktop.desktop";
      };
    })

  ];
}
