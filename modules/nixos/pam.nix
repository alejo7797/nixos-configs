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

    yubico = {
      # Use pam_yubico in HMAC-SHA-1 Challenge-Response mode.
      mode = "challenge-response";
      challengeResponsePath = "/var/lib/yubico";
    };

    # Configure Yubikey-based passwordless sudo.
    services.sudo = lib.mkIf cfg.sudo.yubikey {
      u2fAuth = true;
    };

    # Configure Yubikey-based 2-factor authentication.
    u2f = lib.mkIf cfg.auth.yubikey {
      enable = true;
      control = "requisite";
    };
  };
}
