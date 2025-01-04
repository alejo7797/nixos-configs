{ pkgs, lib, config, ... }: let

  cfg = config.myNixOS.pam;

in {

  options.myNixOS.pam = {

    sudo.yubikey = lib.mkEnableOption "passwordless sudo";

  };

  config.security.pam = {

    yubico = {
      # Use pam_yubico in HMAC-SHA-1 Challenge-Response mode.
      mode = "challenge-response";
      challengeResponsePath = "/var/lib/yubico";
    };

    # Enable Yubikey-based passwordless sudo.
    services.sudo.u2fAuth = cfg.sudo.yubikey;

  };
}
