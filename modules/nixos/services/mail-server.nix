{
  lib,
  config,
  ...
}:

let
  cfg = config.myNixOS.mailserver;

  mkAliases =
    domain: aliases: map (name: "${name}@${domain}") aliases;

  mkDefaultAliases =
    domain: mkAliases domain [ "abuse" "hostmaster" "postmaster" "webmaster" ];
in

{
  options.myNixOS.mailserver.enable = lib.mkEnableOption "email server functionality";

  config = lib.mkIf cfg.enable {

    mailserver = {
      enable = true;

      certificateScheme = "acme";
      fqdn = "mail.patchoulihq.cc";

      domains = [ "patchoulihq.cc" "epelde.net" ];

      loginAccounts = {

        alex = {
          name = "alex@epelde.net";
          aliases = mkDefaultAliases "epelde.net";
          hashedPasswordFile = config.sops.secrets."mailserver/alex".path;
        };

        ewan = {
          name = "ewan@patchoulihq.cc";
          aliases =
            mkDefaultAliases "patchoulihq.cc"
            ++ mkAliases "patchoulihq.cc" [ "blanc" "didac" "root" ];
          hashedPasswordFile = config.sops.secrets."mailserver/ewan".path;
        };

        dmarc = {
          name = "dmarc-reports@patchoulihq.cc";
          aliases = [ "dmarc-reports@epelde.net" ];
          hashedPasswordFile = config.sops.secrets."mailserver/dmarc".path;
        };

      };
    };

    services.postfix = {
      config = {
        # Disable AUTH LOGIN on port 25.
        smtpd_sasl_auth_enable = lib.mkForce false;
      };
    };

    security.acme.certs.${config.mailserver.fqdn} = {
      extraDomainNames = [ "mail.epelde.net" ];
    };

    sops.secrets = {
      # Cloudflare API key for DNS challenges.
      "acme/cloudflare" = { owner = "acme"; };

      # Secure password deployment.
      "mailserver/alex" = { };
      "mailserver/ewan" = { };
      "mailserver/dmarc" = { };
    };
  };
}
