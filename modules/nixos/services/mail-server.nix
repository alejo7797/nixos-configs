{ config, lib, inputs, ... }:

let
  cfg = config.mailserver;

  mkAliases =
    domain: aliases: map (name: "${name}@${domain}") aliases;

  mkDefaultAliases =
    domain: mkAliases domain [ "abuse" "hostmaster" "postmaster" "webmaster" ];
in

{
  imports = [ inputs.nixos-mailserver.nixosModules.default ];

  config = lib.mkIf cfg.enable {

    mailserver = {
      certificateScheme = "acme";
      fqdn = "mail.patchoulihq.cc";

      domains = [
        # My personal email accounts.
        "epelde.net" "patchoulihq.cc"

        # Gitlab & Nextcloud.
        "cloud.patchoulihq.cc"
        "git.patchoulihq.cc"
      ];

      loginAccounts = {

        alex = {
          name = "alex@epelde.net"; aliases = mkDefaultAliases "epelde.net";
          hashedPasswordFile = config.sops.secrets."mailserver/alex".path;
        };

        ewan = {
          name = "ewan@patchoulihq.cc";
          aliases = mkDefaultAliases "patchoulihq.cc"
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

    security.acme.certs."mail.patchoulihq.cc" = {
      extraDomainNames = [ "mail.epelde.net" ];
    };

    sops.secrets = {
      "mailserver/alex" = { };
      "mailserver/dmarc" = { };
      "mailserver/ewan" = { };
    };

  };
}
