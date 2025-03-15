{ lib, ... }: {

  i18n = {

    extraLocaleSettings = {
      # Not quite ISO 8601 :(
      LC_TIME = "ja_JP.UTF-8";
    };

    supportedLocales =

      # Take note of this!
      lib.mkOptionDefault

      [
        "en_US.UTF-8/UTF-8"
        "es_ES.UTF-8/UTF-8"
        "ja_JP.UTF-8/UTF-8"
      ];

  };
}
