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
      networks = [
        "127.0.0.0/8" "[::1]/128"
        "10.20.20.0/24" "[fd00::]/8"
      ];
    };

    security.acme.certs."mail.patchoulihq.cc" = {
      extraDomainNames = "mail.epelde.net";
    };

  };
}
