{ lib, ... }: {

  i18n = {

    # Generally preferrable option.
    defaultLocale = "en_GB.UTF-8";

    extraLocaleSettings = {
      # Not quite ISO 8601 :(
      LC_TIME = "ja_JP.UTF-8";
    };

    supportedLocales =

      # Pulls in C.UTF-8.
      lib.mkOptionDefault

      [
        "es_ES.UTF-8/UTF-8"
        "ja_JP.UTF-8/UTF-8"
      ];

  };
}
