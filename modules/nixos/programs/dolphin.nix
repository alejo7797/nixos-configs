{ config, inputs, lib, pkgs, ... }:

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

        let
          ilya-fedin = import inputs.ilya-fedin { pkgs = prev; };
        in

        {
          libsForQt5 = prev.libsForQt5.overrideScope (
            _: _: { inherit (ilya-fedin) qt5ct; }
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
