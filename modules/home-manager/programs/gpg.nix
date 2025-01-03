{ pkgs, lib, config, ... }: {

  options.myHome.gpg.enable = lib.mkEnableOption "GnuPG configuration";

  config.programs.gpg = lib.mkIf config.myHome.gpg.enable {
    enable = true;

    # Configure my GnuPG user instance.
    settings = {
      keyserver = "hkps://keys.openpgp.org";
      with-keygrip = true;
    };

    # Prevent conflicts with pcscd.
    scdaemonSettings.disable-ccid = true;

    # Import public keys into the keyring.
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
}
