{ pkgs, lib, config, ... }: let

  cfg = config.myHome.thunderbird;

  inherit (pkgs.stdenv.hostPlatform) isDarwin;

  thunderbirdConfigPath =
    if isDarwin then "Library/Thunderbird" else ".thunderbird";

  thunderbirdProfilesPath = if isDarwin then
    "${thunderbirdConfigPath}/Profiles"
  else
    thunderbirdConfigPath;

  enabledCalendars = builtins.attrValues
    (lib.filterAttrs (_: c: c.thunderbird.enable) config.accounts.calendar.accounts);

  enabledCalendarsWithId =
    map (c: c // { id = builtins.hashString "sha256" c.name; }) enabledCalendars;

  enabledContacts = builtins.attrValues
    (lib.filterAttrs (_: c: c.thunderbird.enable) config.accounts.contact.accounts);

  enabledContactsWithId =
    map (c: c // { id = builtins.hashString "sha256" c.name; }) enabledContacts;

  toThunderbirdCalendar = calendar:
    let
      id = calendar.id;
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

  toThunderbirdContacts = contact:
    let
      id = contact.id;
    in
    {
      "ldap_2.servers.${id}.carddav.url" = contact.remote.url;
      "ldap_2.servers.${id}.carddav.username" = contact.remote.userName;
      "ldap_2.servers.${id}.description" = contact.name;
      "ldap_2.servers.${id}.dirType" = 102;
      "ldap_2.servers.${id}.filename" = "abook-1.sqlite";
    };

  mkUserJs = prefs: lib.concatStrings (
    lib.mapAttrsToList (name: value: ''
      user_pref("${name}", ${builtins.toJSON value});
    '') prefs);

in

{

  options = {

    myHome.thunderbird.enable = lib.mkEnableOption "Thunderbird configuration";

    accounts.calendar.accounts = lib.mkOption {
      type = with lib.types; attrsOf (submodule {
        options.thunderbird = {

          enable = lib.mkEnableOption "Thunderbird for this calendar";

          settings = lib.mkOption {
            type = with types; functionTo (attrsOf (oneOf [ bool int str ]));
            default = _: { };
            example = lib.literalExpression ''
              id: {
                "calendar.registry.''${id}.readOnly" = true;
              };
            '';
            description = ''
              Extra settings to add to this Thunderbird calendar configuration.
              The {var}`id` given as argument is an automatically
              generated calendar identifier.
            '';
          };
        };
      });
    };

    accounts.contact.accounts = lib.mkOption {
      type = with lib.types; attrsOf (submodule {
        options.thunderbird = {

          enable = lib.mkEnableOption "Thunderbird for this cardDAV account";

        };
      });
    };
  };

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

      let
        color = (color: id: {
          "calendar.registry.${id}.color" = color;
        });

        identity = (email: id: {
          "calendar.registry.${id}.imip.identity.key" =
            "id_${builtins.hashString "sha256" email}";
        });

        readOnly = (id: { "calendar.registry.${id}.readOnly" = true; });

        refreshInterval = (interval: id: {
          "calendar.registry.${id}.refreshInterval" = interval;
        });
      in

      builtins.mapAttrs

      (
        name: value:
          lib.recursiveUpdate
          {
            thunderbird.enable = true;
          }
          value
      )

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

    # Configure my cardDAV account.
    accounts.contact.accounts = {
      "Contacts" = {
        remote = {
          type = "carddav";
          userName = "ewan";
          url = "https://cloud.patchoulihq.cc/remote.php/dav/addressbooks/users/ewan/contacts";
        };
        thunderbird.enable = true;
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

          # Disable event category colors.
          "calendar.categories.names" = "Holidays";
          "calendar.category.color.holidays" = "";

          # Do not show week numbers.
          "calendar.view-minimonth.showWeekNumber" = false;
        };
      };
    };

    # Configure Thunderbird calendar accounts.
    home.file = lib.mkMerge (

      lib.mapAttrsToList (name: profile: {

        "${thunderbirdProfilesPath}/${name}/user.js".text =

          mkUserJs (builtins.foldl' (a: b: a // b) { } (
            (map (c: toThunderbirdCalendar c) enabledCalendarsWithId)
            ++ (map (c: toThunderbirdContacts c) enabledContactsWithId)
          ));

      }) config.programs.thunderbird.profiles
    );
  };
}
