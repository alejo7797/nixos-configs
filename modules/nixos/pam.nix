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

  config = {

    security.pam = lib.mkMerge [
      {
        yubico = {
          mode = "challenge-response";
          challengeResponsePath = "/var/lib/yubico";
        };

        u2f.settings = {
          authfile = config.sops.secrets."u2f-mappings".path;
          origin = "pam://nitori"; # Host independent.
        };
      }

      # Optional 2-factor authentication.
      (lib.mkIf cfg.auth.yubikey {

        u2f.control = "requisite";

        yubico = {
          enable = true;
          control = "requisite";
        };

        # Some services dislike pam_yubico.
        services = lib.mapAttrs (
          _: _: {
            yubicoAuth = false;
            u2fAuth = true;
          }
        ) {
            hyprlock = { };
            i3lock = { };
            swaylock = { };
          };
      })

      # Optionally enable Yubikey-based passwordless sudo.
      (lib.mkIf cfg.sudo.yubikey { services.sudo.yubicoAuth = true; })
    ];

    warnings = lib.optional (cfg.auth.yubikey && cfg.sudo.yubikey) ''
      Passwordless sudo won't function if myNixOS.pam.auth.yubikey is set.
    '';
  };
}
