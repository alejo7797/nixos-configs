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

      etc =
        let
          applications-menu = # Fix the unpopulated application menus in Dolphin.
            "${pkgs.libsForQt5.kservice}/etc/xdg/menus/applications.menu";
        in
        {
          "/xdg/menus/Hyprland-applications.menu".source = applications-menu;
        };

      pathsToLink = [ "/share/color-schemes" ];

    };

    nixpkgs.overlays = [
      (final: prev:
        let
          ilya-fedin = import inputs.ilya-fedin { pkgs = prev; };
        in
        {
          libsForQt5 = prev.libsForQt5.overrideScope (
            _: _: { inherit (ilya-fedin) qt5ct; }
          );

          qt6Packages = prev.qt6Packages.overrideScope (
            _: _: {
              qt6ct = ilya-fedin.qt6ct.overrideAttrs (oldAttrs: {
                src = final.fetchFromGitHub {
                  owner = "trialuser02";
                  repo = "qt6ct";
                  rev = oldAttrs.version;
                  hash = "sha256-MmN/qPBlsF2mBST+3eYeXaq+7B3b+nTN2hi6CmxrILc=";
                };
              });
            }
          );
        }
      )
    ];

  };
}
