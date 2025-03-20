{
  lib,
  config,
  ...
}:

let
  cfg = config.myNixOS.graphical;
in

{
  options.myNixOS = {
    graphical.enable = lib.mkEnableOption "common graphical utilities";
  };

  config = lib.mkIf cfg.enable {

    programs = {
      appimage = {
        enable = true;
        binfmt = true;
      };
    };

    services = {


      geoclue2 = {
        enable = true;
        # See https://github.com/NixOS/nixpkgs/issues/321121.
        geoProviderUrl = "https://api.beacondb.net/v1/geolocate";
      };

    };

    security.pam.services.login.enableGnomeKeyring = true;

    xdg.portal.xdgOpenUsePortal = true;

    environment.sessionVariables = {
      # Try to improve Java applications' font rendering.
      _JAVA_OPTIONS = "-Dawt.useSystemAAFontSettings=lcd";

      # Screen scaling for QT applications.
      QT_FONT_DPI = 120;
    };
  };
}
