{ lib, ... }: {

  # TODO: with 25.05 came support for extensions
  # and also for declarative feed accounts

  accounts = {

    email.accounts =

      let
        oauth_imap = id: { "mail.server.server_${id}.authMethod" = 10; };
        oauth_smtp = id: { "mail.smtpserver.smtp_${id}.authMethod" = 10; };
        reply_on_top = id: { "mail.identity.id_${id}.reply_on_top" = 1; };
        sent_no_copy = id: { "mail.identity.id_${id}.fcc" = false; };

        default_config = {
          perIdentitySettings = reply_on_top;
        };

        gmail_config = {
          perIdentitySettings =
            id: (oauth_smtp id // reply_on_top id);
          settings = oauth_imap;
        };

        outlook_config = {
          perIdentitySettings =
            id: (oauth_smtp id // reply_on_top id // sent_no_copy id);
          settings = oauth_imap;
        };
      in

      builtins.mapAttrs

      (
        _: account:
        lib.mkMerge [
          {
            realName  = lib.mkDefault "Alex Epelde";
            userName  = lib.mkDefault account.address;
            smtp.host = lib.mkDefault account.imap.host;
            smtp.port = lib.mkDefault 587;
            imap.port = lib.mkDefault 993;
            thunderbird.enable = true;
          }
          account
        ]
      )

      {
        Alex = {
          primary = true;
          address = "alex@epelde.net";
          imap.host = "mail.epelde.net";
          smtp.tls.useStartTls = true;
          thunderbird = default_config;
        };

        Ewan = {
          realName = "Ewan";
          address = "ewan@patchoulihq.cc";
          imap.host = "mail.patchoulihq.cc";
          smtp.tls.useStartTls = true;
          thunderbird = default_config;
        };

        Gmail = {
          address = "alexepelde@gmail.com";
          flavor = "gmail.com";
          thunderbird = gmail_config;
        };

        Harvard = {
          address = "epelde@math.harvard.edu";
          flavor = "outlook.office365.com";
          folders.trash = "Deleted Items";
          thunderbird = outlook_config;
        };

        Outlook = {
          address = "alexepelde@outlook.es";
          flavor = "outlook.office365.com";
          folders.trash = "Deleted";
          thunderbird = outlook_config;
        };

        Cambridge = {
          address = "ae433@cantab.ac.uk";
          flavor = "outlook.office365.com";
          folders.trash = "Deleted Items";
          thunderbird = outlook_config;
        };
      };

    calendar.accounts =

      let
        color =
          color: id: {
            "calendar.registry.${id}.color" = color;
          };

        identity =
          email: id: {
            "calendar.registry.${id}.imip.identity.key" = "id_${builtins.hashString "sha256" email}";
          };

        readOnly = id: { "calendar.registry.${id}.readOnly" = true; };

        refreshInterval =
          interval: id: {
            "calendar.registry.${id}.refreshInterval" = interval;
          };
      in

      {
        "Personal Calendar" = {
          primary = true;
          remote = {
            type = "caldav";
            userName = "ewan";
            url = "https://cloud.patchoulihq.cc/remote.php/dav/calendars/ewan/personal";
          };
          thunderbird.settings = id: (
            color "#2d72be" id
            // refreshInterval 1 id
            // identity "Alex" id
          );
        };

        "Boston Topology"= {
          remote = {
            type = "http";
            url = "https://calendar.google.com/calendar/ical/028i07liimdqltnn999mpdqek4%40group.calendar.google.com/public/basic.ics";
          };
          thunderbird.settings = id: (
            color "#0b7f39" id
            // readOnly id
            // identity "Harvard" id
          );
        };

        "Contact Birthdays" = {
          remote = {
            type = "caldav";
            userName = "ewan";
            url = "https://cloud.patchoulihq.cc/remote.php/dav/calendars/ewan/contact_birthdays";
          };
          thunderbird.settings = id: (
            color "#d81b60" id
            // readOnly id
            // identity "Alex" id
          );
        };

        "Holidays in Spain" = {
          remote = {
            type = "caldav";
            userName = "ewan";
            url = "https://cloud.patchoulihq.cc/remote.php/dav/calendars/ewan/holidays_in_spain";
          };
          thunderbird.settings = id: (
            color "#0b7f39" id
            // identity "Alex" id
          );
        };

        "Holidays in USA" = {
          remote = {
            type = "http";
            url = "https://www.officeholidays.com/ics-clean/usa/massachusetts";
          };
          thunderbird.settings = id: (
            color "#0b7f39" id
            // readOnly id
            // identity "Alex" id
          );
        };
      };

    contacts.accounts =

      let
        nextcloud = id: {
          "ldap_2.servers.${id}.dirType" = 102;
          "ldap_2.servers.${id}.filename" = "abook-1.sqlite";
        };
      in

      {
        "Contacts" = {
          remote = {
            type = "carddav";
            userName = "ewan";
            url = "https://cloud.patchoulihq.cc/remote.php/dav/addressbooks/users/ewan/contacts";
          };
          thunderbird.settings = nextcloud;
        };
      };

  };

}
