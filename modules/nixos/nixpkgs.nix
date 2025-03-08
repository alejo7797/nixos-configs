{ inputs, ... }: {

  nixpkgs = {
    config.allowUnfree = true;

    overlays = [

      inputs.my-expressions.overlays.default
      inputs.nix-minecraft.overlays.default
      inputs.nur.overlays.default

      (final: _: {
        bolt-launcher = final.callPackage (import "${inputs.nixpkgs-unstable}/pkgs/by-name/bo/bolt-launcher/package.nix") { libgbm = final.mesa; };
        spotify = final.callPackage (import "${inputs.nixpkgs-unstable}/pkgs/by-name/sp/spotify/package.nix") { libgbm = final.mesa; };
      })

      (final: _: {
        joplin-desktop = final.callPackage (
          { lib, appimageTools, fetchurl, makeWrapper }:
          let
            pname = "joplin-desktop";
            version = "3.1.24";

            src = fetchurl {
              url = "https://github.com/laurent22/joplin/releases/download/v${version}/Joplin-${version}.AppImage";
              sha256 = "sha256-ImFB4KwJ/vAHtZUbLAdnIRpd+o2ZaXKy9luw/jnPLSE=";
            };

            appimageContents = appimageTools.extractType2 {
              inherit pname version src;
            };
          in

          appimageTools.wrapType2 rec {
            inherit pname version src;
            nativeBuildInputs = [ makeWrapper ];

            profile = ''
              export LC_ALL=C.UTF-8
            '';

            extraInstallCommands = ''
              wrapProgram $out/bin/${pname} \
                --add-flags "\''${NIXOS_OZONE_WL:+\''${WAYLAND_DISPLAY:+--ozone-platform=wayland --enable-features=WaylandWindowDecorations --enable-wayland-ime=true}}"
              install -Dm444 ${appimageContents}/@joplinapp-desktop.desktop $out/share/applications/joplin-desktop.desktop
              substituteInPlace $out/share/applications/joplin-desktop.desktop \
                --replace 'Exec=AppRun' 'Exec=${pname}'
            '';

            meta = with lib; {
              description = "Open source note taking and to-do application with synchronisation capabilities";
              mainProgram = "joplin-desktop";
              homepage = "https://joplinapp.org";
              license = licenses.agpl3Plus;
              platforms = [ "x86_64-linux" ];
            };
          }
        ) { };
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
