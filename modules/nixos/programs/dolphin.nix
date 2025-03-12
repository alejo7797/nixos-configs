{
  lib,
  config,
  pkgs,
  ...
}:

let
  cfg = config.myNixOS.dolphin;
in

{
  options.myNixOS.dolphin.enable = lib.mkEnableOption "the Dolphin ecosystem";

  config = lib.mkIf cfg.enable {

    # Pull this in just in case.
    myNixOS.graphical.enable = true;

  environment = {

    # Install Dolphin and all that's good with it.
    systemPackages = with pkgs.kdePackages; [

      ark dolphin dolphin-plugins ffmpegthumbs
      gwenview kde-cli-tools kfind kimageformats
      kdegraphics-thumbnailers kio-admin konsole
      kio-extras qtimageformats qtsvg taglib

    ];

    etc =
      let
        plasma-applications = # This fixes the unpopulated application menus in Dolphin.
          "${pkgs.kdePackages.plasma-workspace}/etc/xdg/menus/plasma-applications.menu";
      in
      {
        "/xdg/menus/i3-applications.menu".source = plasma-applications;
        "/xdg/menus/Hyprland-applications.menu".source = plasma-applications;
        "/xdg/menus/sway-applications.menu".source = plasma-applications;
      };

    pathsToLink = [ "/share/color-schemes" ];

  };

    nixpkgs.overlays = [
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
          });

        qt6Packages = prev.qt6Packages.overrideScope (
          qt6-final: qt6-prev: with kdePackages; with qt6-final; {
            qt6ct = qt6-prev.qt6ct.overrideAttrs (oldAttrs: {
              src = fetchFromGitHub {
                owner = "ilya-fedin";
                repo = "qt6ct";
                tag = oldAttrs.version;
                hash = "sha256-ePY+BEpEcAq11+pUMjQ4XG358x3bXFQWwI1UAi+KmLo=";
              };

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
