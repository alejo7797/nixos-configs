{ config, lib, pkgs, ... }:

let
  cfg = config.programs.my.dolphin;
in

{
  options.programs.my.dolphin.enable = lib.mkEnableOption "the Dolphin ecosystem";

  config = lib.mkIf cfg.enable {

    environment = {

      systemPackages = with pkgs.kdePackages; [

        ark
        dolphin
        dolphin-plugins
        ffmpegthumbs
        gwenview
        kde-cli-tools
        kfind
        kimageformats
        kdegraphics-thumbnailers
        konsole
        kio-extras
        qtimageformats
        qtsvg
        taglib

      ];

      etc = {
        "/xdg/menus/Hyprland-applications.menu".source = # Fix empty Dolphin menus.
          "${pkgs.kdePackages.plasma-workspace}/etc/xdg/menus/plasma-applications.menu";
      };

      pathsToLink = [ "/share/color-schemes" ];

    };

    nixpkgs.overlays = [

      (
        final: prev:

        {
          libsForQt5 = prev.libsForQt5.overrideScope (
            qt5-final: qt5-prev: {

              qt5ct = qt5-prev.qt5ct.overrideAttrs (oldAttrs: rec {

                version = "1.8";

                src = final.fetchurl {
                  url = "mirror://sourceforge/qt5ct/qt5ct-${version}.tar.bz2";
                  sha256 = "sha256-I7dAVEFepBJDKHcu+ab5UIOpuGVp4SgDSj/3XfrYCOk=";
                };

                buildInputs = with qt5-final; oldAttrs.buildInputs ++ [
                  qtquickcontrols2 kconfig kconfigwidgets kiconthemes
                ];

                nativeBuildInputs = with qt5-final; [
                  final.cmake wrapQtAppsHook qttools
                ];

                patches = [
                  (final.fetchurl {
                    url = "https://raw.githubusercontent.com/ilya-fedin/nur-repository/refs/heads/master/pkgs/qt5ct/qt5ct-shenanigans.patch";
                    hash = "sha256-fziJn5xcSdtqwf69p36god0342n5zSHdJScjRw/IbgY=";
                  })
                ];

                cmakeFlags = [
                  "-DPLUGINDIR=${placeholder "out"}/${qt5-final.qtbase.qtPluginPrefix}"
                ];

              });

            }
          );

          qt6Packages = prev.qt6Packages.overrideScope (
            qt6-final: qt6-prev: {

              qt6ct = qt6-prev.qt6ct.overrideAttrs (oldAttrs: rec {

                version = "0.10";

                src = final.fetchFromGitHub {
                  owner = "ilya-fedin"; repo = "qt6ct"; tag = version;
                  hash = "sha256-ePY+BEpEcAq11+pUMjQ4XG358x3bXFQWwI1UAi+KmLo=";
                };

                buildInputs = with final.kdePackages; oldAttrs.buildInputs ++ [
                  qt6-final.qtdeclarative kconfig kcolorscheme kiconthemes
                ];

              });

            }
          );
        }
      )

    ];

  };
}
