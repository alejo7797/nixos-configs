{ config, lib, ... }:

let
  cfg = config.programs.thunderbird;

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

    accounts.contacts.accounts = lib.mkOption {
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

    programs.thunderbird.profiles = {

      "${config.home.username}.default" = {

        isDefault = true;

        search = {
          default = "ddg";
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

          # Weeks start on Monday.
          "calendar.week.start" = 1;

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
