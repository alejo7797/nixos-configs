{ pkgs, lib, config, ... }: {

  options.myHome.thunderbird.enable = lib.mkEnableOption "thunderbird configuration";

  config = lib.mkIf config.myHome.thunderbird.enable {

    # Configure my email accounts.
    accounts.email.accounts = lib.mapAttrs

    (
      name: settings:
      {
        realName = "Alex Epelde";
        userName = settings.address;
        thunderbird.enable = true;
      }
      // settings
    )

    {
      Alex = {
        address = "alex@epelde.net";
        primary = true;
        imap.host = "mail.epelde.net";
        smtp.host = "mail.epelde.net";
        smtp.tls.useStartTls = true;
      };

      Ewan = {
        address = "ewan@patchoulihq.cc";
        realName = "ewan";
        imap.host = "mail.patchoulihq.cc";
        smtp.host = "mail.patchoulihq.cc";
        smtp.tls.useStartTls = true;
      };

      Gmail = {
        address = "alexepelde@gmail.com";
        flavor = "gmail.com";
      };

      Harvard = {
        address = "epelde@math.harvard.edu";
        flavor = "outlook.office365.com";
      };

      Outlook = {
        address = "alexepelde@outlook.es";
        flavor = "outlook.office365.com";
      };

      Cambridge = {
        address = "ae433@cantab.ac.uk";
        flavor = "outlook.office365.com";
      };
    };

    # Configure Thunderbird.
    programs.thunderbird = {
      enable = true;
      profiles."${config.home.username}.default" = {

        isDefault = true;

        settings = {

        };

      };
    };

  };
}
