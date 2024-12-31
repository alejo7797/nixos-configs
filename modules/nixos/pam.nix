{ pkgs, lib, config, ... }: {

  options.myNixOS.passwordlessSudo.enable = lib.mkEnableOption "passwordless sudo";

  config.security.pam = {

    u2f = lib.mkIf config.myNixOS.passwordlessSudo.enable {

      # Use a YubiKey instead of a password.
      control = "sufficient";

    };

    yubico = {

      # Use pam_yubico in HMAC-SHA-1 Challenge-Response mode.
      mode = "challenge-response";
      challengeResponsePath = "/var/lib/yubico";

    };

    services.sudo.u2fAuth = config.myNixOS.passwordlessSudo.enable;

  };
}
