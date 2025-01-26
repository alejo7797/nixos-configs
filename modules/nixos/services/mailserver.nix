{
  lib,
  config,
  ...
}:

let
  cfg = config.myNixOS.mailserver;

  defaultAliases =
    domain: [
      "abuse@${domain}"
      "hostmaster@${domain}"
      "postmaster@${domain}"
      "webmaster@${domain}"
    ];
in

{
  options.myNixOS.mailserver.enable = lib.mkEnableOption "email server functionality";

  config = lib.mkIf cfg.enable {

    mailserver = {
      enable = true;

      certificateScheme = "acme";
      fqdn = "mail.patchoulihq.cc";

      domains = [
        "patchoulihq.cc"
        "epelde.net"
      ];

      loginAccounts = {

        alex = {
          name = "alex@epelde.net";
          aliases = defaultAliases "epelde.net";
          hashedPasswordFile = config.sops-nix.secrets."mailserver/alex".path;
        };

        ewan = {
          name = "ewan@patchoulihq.cc";
          aliases = defaultAliases "patchoulihq.cc" ++
            [
              "blanc@patchoulihq.cc"
              "didac@patchoulihq.cc"
              "root@patchoulihq.cc"
            ];
          hashedPasswordFile = config.sops-nix.secrets."mailserver/ewan".path;
        };

        dmarc = {
          name = "dmarc-reports@patchoulihq.cc";
          aliases = [ "dmarc-reports@epelde.net" ];
          hashedPasswordFile = config.sops-nix.secrets."mailserver/dmarc".path;
        };

      };
    };

    services.postfix = {
      config = {
        # Disable AUTH LOGIN on port 25.
        smtpd_sasl_auth_enable = false;
      };
    };

    security.acme.certs."mail.patchoulihq.cc" = {
      extraDomainNames = "mail.epelde.net";
    };

  };
}
