{
  lib,
  config,
  ...
}:

let
  cfg = config.myNixOS.pam;
in

{
  options.myNixOS.pam = {
    sudo.yubikey = lib.mkEnableOption "passwordless sudo";
    auth.yubikey = lib.mkEnableOption "2-factor authentication";
  };

  config.security.pam = {

    yubico =
      {
        # Use pam_yubico in HMAC-SHA-1 Challenge-Response mode.
        id = [ "26559201" ];
        mode = "challenge-response";
        challengeResponsePath = "/var/lib/yubico";
      }

      // lib.mkIf cfg.auth.yubikey {
        # Enforce Yubikey-based 2-factor authentication.
        enable = true;
        control = "requisite";
      };

    # Enable Yubikey-based passwordless sudo.
    services.sudo.u2fAuth = cfg.sudo.yubikey;

  };
}
