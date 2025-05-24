{ config, lib, pkgs, ... }:

let
  cfg = config.my.yubikey;


in

{
  options.my.yubikey = {
    sudo = lib.mkEnableOption "passwordless sudo";
    _2fa = lib.mkEnableOption "2-factor authentication";
  };

  config = {

    services.udev.packages = [

      pkgs.yubikey-personalization

      (pkgs.writeTextDir "etc/udev/rules.d/80-yubikey.rules" ''
        # Take actions when a Yubikey is plugged in or removed using custom systemd user units.
        ENV{ID_VENDOR_ID}=="1050", ENV{ID_MODEL_ID}=="0407", SYMLINK+="yubikey", TAG+="systemd"
      '')

    ];

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
      (lib.mkIf cfg._2fa {

        u2f.control = "requisite";

        yubico = {
          enable = true;
          control = "requisite";
        };

        # Some services dislike pam_yubico.
        services =
          lib.mapAttrs
            (_: _: {
              yubicoAuth = false;
              u2fAuth = true;
            })
            {
              hyprlock = { };
              i3lock = { };
              swaylock = { };
            };
      })

      # Optionally enable Yubikey-based passwordless sudo.
      (lib.mkIf cfg.sudo { services.sudo.yubicoAuth = true; })
    ];

    warnings = lib.optional (cfg.sudo && cfg._2fa) ''
      Passwordless sudo won't work if my.yubikey._2fa is set.
    '';
  };
}
