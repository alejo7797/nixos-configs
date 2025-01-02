{ pkgs, lib, config, ... }: {

  options.myHome.gpg.enable = lib.mkEnableOption "GnuPG configuration";

  config.programs.gpg = lib.mkIf config.myHome.gpg.enable {

    # Configure my GnuPG user instance.
    enable = true;

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
      {
        # Shinobu sops host key.
        source = ../../../keys/shinobu.asc;
        trust = "full";
      }
    ];

  };
}
