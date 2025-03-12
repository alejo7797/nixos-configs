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

          appimageTools.wrapType2 {
            inherit pname version src;
            nativeBuildInputs = [ makeWrapper ];

            profile = ''
              export LC_ALL=C.UTF-8
            '';

            extraInstallCommands = ''
              wrapProgram $out/bin/joplin-desktop \
                --add-flags "\''${NIXOS_OZONE_WL:+\''${WAYLAND_DISPLAY:+--ozone-platform=wayland --enable-features=WaylandWindowDecorations --enable-wayland-ime=true}}"
              install -Dm644 ${appimageContents}/@joplinapp-desktop.desktop $out/share/applications/joplin-desktop.desktop
              substituteInPlace $out/share/applications/joplin-desktop.desktop \
                --replace 'Exec=AppRun' 'Exec=joplin-desktop'
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
    ];
  };
}
