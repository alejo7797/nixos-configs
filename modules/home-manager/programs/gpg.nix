{
  lib,
  config,
  ...
}:

let
  cfg = config.myHome.gpg;
in

{
  options.myHome.gpg.enable = lib.mkEnableOption "GnuPG configuration";

  config = lib.mkIf cfg.enable {

    programs.gpg = {
      enable = true;

      settings = {
        keyserver = "hkps://keys.openpgp.org";
        with-keygrip = true;
      };

      # Prevent conflicts with pcscd.
      scdaemonSettings.disable-ccid = true;

      publicKeys = [
        {
          # My personal OpenPGP public key.
          source = builtins.fetchurl {
            url = "https://alex.epelde.net/public-key.asc";
            sha256 = "1mijaxbqrc5mbwm9npbaf1vk8zbrrv3f4fc956kj98j7phb284gh";
          };

          # Appropriate trust level.
          trust = "ultimate";
        }
      ];
    };
  };
}
