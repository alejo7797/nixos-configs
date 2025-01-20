{
  lib,
  config,
  ...
}:

let
  cfg = config.myHome.thunderbird;

  enabledCalendars = builtins.attrValues
    (lib.filterAttrs (_: c: c.thunderbird.enable) config.accounts.calendar.accounts);

  enabledCalendarsWithId =
    map (c: c // { id = builtins.hashString "sha256" c.name; }) enabledCalendars;

  enabledContacts = builtins.attrValues
    (lib.filterAttrs (_: c: c.thunderbird.enable) config.accounts.contact.accounts);

  enabledContactsWithId =
    map (c: c // { id = builtins.hashString "sha256" c.name; }) enabledContacts;

  toThunderbirdCalendar =
    calendar:
    let
      inherit (calendar) id;
    in
    {
      "calendar.registry.${id}.cache.enabled" = true;
      "calendar.registry.${id}.main-in-composite" = true;
      "calendar.registry.${id}.name" = calendar.name;
      "calendar.registry.${id}.uri" = calendar.remote.url;
    }
    // lib.optionalAttrs (calendar.remote.type == "caldav") {
      "calendar.registry.${id}.type" = "caldav";
      "calendar.registry.${id}.username" = calendar.remote.userName;
    }
    // lib.optionalAttrs (calendar.remote.type == "http") {
      "calendar.registry.${id}.type" = "ics";
    }
    // lib.optionalAttrs calendar.primary {
      "calendar.registry.${id}.calendar-main-default" = true;
    }
    // calendar.thunderbird.settings id;

  toThunderbirdContacts =
    contacts:
    let
      inherit (contacts) id;
    in
    {
      "ldap_2.servers.${id}.carddav.url" = contacts.remote.url;
      "ldap_2.servers.${id}.carddav.username" = contacts.remote.userName;
      "ldap_2.servers.${id}.description" = contacts.name;
    }
    // contacts.thunderbird.settings id;

  mkUserJs =
    prefs:
    lib.concatStrings (
      lib.mapAttrsToList (name: value: ''
        user_pref("${name}", ${builtins.toJSON value});
      '') prefs
    );
in

{
  options = {
    myHome.thunderbird.enable = lib.mkEnableOption "Thunderbird";

    accounts.calendar.accounts = lib.mkOption {
      type = with lib.types; attrsOf (submodule {
        options.thunderbird = {

          enable = lib.mkEnableOption "Thunderbird for this calendar" // { default = true; };

          settings = lib.mkOption {
            type = with types; functionTo (attrsOf (oneOf [ bool int str ]));
            default = _: { };
            example = lib.literalExpression ''
              id: {
                "calendar.registry.''${id}.readOnly" = true;
              };
            '';
            description = ''
              Extra settings to add to this Thunderbird calendar
              configuration. The {var}`id` given as argument is
              an automatically generated calendar identifier.
            '';
          };
        };
      });
    };

    accounts.contact.accounts = lib.mkOption {
      type = with lib.types; attrsOf (submodule {
        options.thunderbird = {

          enable = lib.mkEnableOption "Thunderbird for this cardDAV account" // { default = true; };

          settings = lib.mkOption {
            type = with types; functionTo (attrsOf (oneOf [ bool int str ]));
            default = _: { };
            example = lib.literalExpression ''
              id: {
                "ldap_2.servers.''${id}.dirType" = 102;
              };
            '';
            description = ''
              Extra settings to add to this Thunderbird cardDAV
              configuration. The {var}`id` given as argument is
              an automatically generated account identifier.
            '';
          };
        };
      });
    };
  };

  config = lib.mkIf cfg.enable {

    accounts = {

      email.accounts =

        let
          oauth_imap = id: { "mail.server.server_${id}.authMethod" = 10; };
          oauth_smtp = id: { "mail.smtpserver.smtp_${id}.authMethod" = 10; };
          reply_on_top = id: { "mail.identity.id_${id}.reply_on_top" = 1; };
          sent_no_copy = id: { "mail.identity.id_${id}.fcc" = false; };

          default_cfg = {
            perIdentitySettings = reply_on_top;
          };

          gmail_cfg = {
            perIdentitySettings =
              id: (oauth_smtp id // reply_on_top id);
            settings = oauth_imap;
          };

          outlook_cfg = {
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
            thunderbird = default_cfg;
          };

          Ewan = {
            realName = "Ewan";
            address = "ewan@patchoulihq.cc";
            imap.host = "mail.patchoulihq.cc";
            smtp.tls.useStartTls = true;
            thunderbird = default_cfg;
          };

          Gmail = {
            address = "alexepelde@gmail.com";
            flavor = "gmail.com";
            thunderbird = gmail_cfg;
          };

          Harvard = {
            address = "epelde@math.harvard.edu";
            flavor = "outlook.office365.com";
            folders.trash = "Deleted Items";
            thunderbird = outlook_cfg;
          };

          Outlook = {
            address = "alexepelde@outlook.es";
            flavor = "outlook.office365.com";
            folders.trash = "Deleted";
            thunderbird = outlook_cfg;
          };

          Cambridge = {
            address = "ae433@cantab.ac.uk";
            flavor = "outlook.office365.com";
            folders.trash = "Deleted Items";
            thunderbird = outlook_cfg;
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
          "Nextcloud" = {
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

          "Holidays" = {
            remote = {
              type = "caldav";
              userName = "ewan";
              url = "https://cloud.patchoulihq.cc/remote.php/dav/calendars/ewan/holidays";
            };
            thunderbird.settings = id: (
              color "#0b7f39" id
              // identity "Alex" id
            );
          };
        };

      contact.accounts =

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

          # Show 11 hours in the calendar view.
          "calendar.view.visiblehours" = 11;

          # Do not show week numbers.
          "calendar.view-minimonth.showWeekNumber" = false;

          # Disable event category colors.
          "calendar.categories.names" = "Holidays";
          "calendar.category.color.holidays" = "";
        };
      };
    };

    # Configure Thunderbird calendar and cardDAV accounts.
    home.file = lib.mkMerge (
      lib.mapAttrsToList (name: _: {
        ".thunderbird/${name}/user.js".text =

          mkUserJs (builtins.foldl' (a: b: a // b) { } (
            (map toThunderbirdCalendar enabledCalendarsWithId)
            ++ (map toThunderbirdContacts enabledContactsWithId)
          ));

      }) config.programs.thunderbird.profiles
    );
  };
}
