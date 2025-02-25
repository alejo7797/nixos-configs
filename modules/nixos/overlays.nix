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

    inputs.my-scripts.overlays.default
    inputs.my-expressions.overlays.default
    inputs.nix-minecraft.overlays.default

    (_: prev: {
      inherit (unstable prev.system)
        bolt-launcher
        joplin-desktop
        lutris spotify
        ;
    })

    (_: prev: {
      sage = prev.sage.override {
        # Access the SnapPy Python module.
        extraPythonPackages = ps: [ ps.snappy ];
        requireSageTests = false;
      };
    })

    (_: prev: {
      lutris = prev.lutris.override {
        extraLibraries = pkgs: with pkgs;
          [ libgudev libvdpau speex ];
      };
    })

    (_: prev: {
      joplin-desktop = prev.joplin-desktop // {
        desktopFile = "@joplinapp-desktop.desktop";
      };
    })

  ];
}
