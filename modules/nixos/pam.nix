{ pkgs, lib, config, ... }: {

  options.myNixOS = {
    
    yubicoAuth = lib.mkEnableOption "passwordless authentication";

  };

  config.security.pam = {

    yubico = lib.mkIf config.myNixOS.yubicoAuth {

      # Enable YubiKey-based authentication.
      enable = true;

      # Use pam_yubico in HMAC-SHA-1 Challenge-Response mode.
      mode = "challenge-response";
      challengeResponsePath = "/var/lib/yubico";

      # Use a YubiKey instead of a password.
      control = "sufficient";

    };
  };
}
