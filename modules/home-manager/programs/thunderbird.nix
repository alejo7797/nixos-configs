{ pkgs, lib, config, ... }: let

  cfg = config.myHome.thunderbird;

in {

  options.myHome.thunderbird.enable = lib.mkEnableOption "Thunderbird configuration";

  config = lib.mkIf cfg.enable {

    # Configure my email accounts.
    accounts.email.accounts =

      let
        oauth = (id: { "mail.server.server_${id}.authMethod" = 10; });
      in

      builtins.mapAttrs

      (
        name: value:
          lib.recursiveUpdate
          {
            realName = "Alex Epelde";
            userName = value.address;
            imap.port = 993;
            thunderbird.enable = true;
          }
          value
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

    # Configure my calendars.
    accounts.calendar.accounts =
      {
        "Nextcloud" = {
          primary = true;
          remote = {
            type = "caldav";
            userName = "ewan";
            url = "https://cloud.patchoulihq.cc/remote.php/dav/calendars/ewan/personal";
          };
         };

        "Boston Topology"= {
          remote = {
            type = "http";
            url = "https://calendar.google.com/calendar/ical/028i07liimdqltnn999mpdqek4%40group.calendar.google.com/public/basic.ics";
          };
         };

        "Contact Birthdays" = {
          remote = {
            type = "caldav";
            userName = "ewan";
            url = "https://cloud.patchoulihq.cc/remote.php/dav/calendars/ewan/contact_birthdays";
          };
        };

        "Holidays" = {
        remote = {
            type = "caldav";
            userName = "ewan";
            url = "https://cloud.patchoulihq.cc/remote.php/dav/calendars/ewan/holidays";
          };
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
