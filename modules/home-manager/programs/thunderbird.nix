{ pkgs, lib, config, ... }: {

  options.myHome.thunderbird.enable = lib.mkEnableOption "thunderbird configuration";

  config = lib.mkIf config.myHome.thunderbird.enable {

    # Configure my email accounts.
    accounts.email.accounts =

      let
        oauth = (id: { "mail.server.server_${id}.authMethod" = 10; });
      in

      lib.mapAttrs

      (
        name: settings:
          lib.recursiveUpdate
          {
            realName = "Alex Epelde";
            userName = settings.address;
            imap.port = 993;
            thunderbird.enable = true;
          }
          settings
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
          thunderbird.settings = id: oauth id;
        };

        Harvard = {
          address = "epelde@math.harvard.edu";
          flavor = "outlook.office365.com";
          folders.trash = "Deleted Items";
          thunderbird.settings = id: oauth id;
        };

        Outlook = {
          address = "alexepelde@outlook.es";
          flavor = "outlook.office365.com";
          folders.trash = "Deleted";
          thunderbird.settings = id: oauth id;
        };

        Cambridge = {
          address = "ae433@cantab.ac.uk";
          flavor = "outlook.office365.com";
          folders.trash = "Deleted Items";
          thunderbird.settings = id: oauth id;
        };
      };

    # Configure Thunderbird.
    programs.thunderbird = {
      enable = true;
      profiles."${config.home.username}.default" = {

        isDefault = true;

        search = {
          default = "DuckDuckGo";
          force = true;
        };

        settings = {
          # Privacy settings.
          "network.cookie.cookieBehavior" = 1;
          "places.history.enabled" = false;
          "privacy.donottrackheader.enabled" = true;
          "datareporting.healthreport.uploadEnabled" = false;

          # Set a delay before marking messages as read.
          "mailnews.mark_message_read.delay" = true;

          # Disable the start page.
          "mailnews.start_page.enabled" = false;
        };

      };
    };

  };
}
