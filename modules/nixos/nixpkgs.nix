{ inputs, ... }: {

  nixpkgs = {
    config.allowUnfree = true;

    overlays = [

      inputs.my-expressions.overlays.default
      inputs.nix-minecraft.overlays.default
      inputs.nur.overlays.default

      (final: _: {
        bolt-launcher = final.callPackage (import "${inputs.nixpkgs-unstable}/pkgs/by-name/bo/bolt-launcher/package.nix") { libgbm = final.mesa; };

        joplin-desktop = final.callPackage (import "${inputs.nixpkgs-unstable}/pkgs/by-name/jo/joplin-desktop/package.nix") { };

        spotify = final.callPackage (import "${inputs.nixpkgs-unstable}/pkgs/by-name/sp/spotify/package.nix") { libgbm = final.mesa; };
      })

      (final: prev: {
        joplin-desktop = prev.joplin-desktop // {
          desktopItem = final.makeDesktopItem {
            name = "joplin-desktop";
            desktopName = "Joplin";
            exec = "joplin-desktop";
          };
        };

        uwsm = prev.uwsm.overrideAttrs {
          postPatch = ''
            substituteInPlace uwsm/misc.py \
              --replace-fail '\A[a-zA-Z0-9_]' '\A[a-zA-Z0-9_@]'
          '';
        };
      })

      (final: prev: with final; {
        libsForQt5 = prev.libsForQt5.overrideScope (
          qt5-final: qt5-prev: with qt5-final; {
            qt5ct = qt5-prev.qt5ct.overrideAttrs (oldAttrs: {
              buildInputs = oldAttrs.buildInputs ++
                [
                  qtquickcontrols2 kconfig
                  kconfigwidgets kiconthemes
                ];

              nativeBuildInputs =  [
                cmake wrapQtAppsHook qttools
              ];

              patches = [
                (fetchurl {
                  url = "https://raw.githubusercontent.com/ilya-fedin/nur-repository/refs/heads/master/pkgs/qt5ct/qt5ct-shenanigans.patch";
                  hash = "sha256-fziJn5xcSdtqwf69p36god0342n5zSHdJScjRw/IbgY=";
                })
              ];

              cmakeFlags = [
                "-DPLUGINDIR=${placeholder "out"}/${qtbase.qtPluginPrefix}"
              ];

            });
          }
        );

        qt6Packages = prev.qt6Packages.overrideScope (
          qt6-final: qt6-prev: with kdePackages; with qt6-final; {
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

    ];
  };
}
