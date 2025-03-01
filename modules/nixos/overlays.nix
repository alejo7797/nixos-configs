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

    inputs.my-expressions.overlays.default
    inputs.nix-minecraft.overlays.default

    (_: prev: {
      inherit (unstable prev.system)
        bolt-launcher
        joplin-desktop
        lutris spotify
        ;
    })

    (final: prev: with final; {
      qt6Packages = prev.qt6Packages.overrideScope (
        _: qt6-prev: with kdePackages; {
          qt6ct = qt6-prev.qt6ct.overrideAttrs (oldAttrs: {
            buildInputs = oldAttrs.buildInputs ++
              [
                qtdeclarative kconfig
                kcolorscheme kiconthemes
              ];

            nativeBuildInputs =  [
              cmake wrapQtAppsHook qttools
            ];

            cmakeFlags = [
              "-DPLUGINDIR=${placeholder "out"}/${qtbase.qtPluginPrefix}"
            ];
          });
        }
      );
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
