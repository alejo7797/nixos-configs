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
      kdePackages = prev.kdePackages.overrideScope (
        kde-final: kde-prev: with kde-final; {
          qt6ct = kde-prev.qt6ct.overrideAttrs (oldAttrs: {
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
