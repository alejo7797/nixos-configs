{
  lib,
  ...
}:

{
  i18n = {

    # Set the default locale.
    defaultLocale = "en_US.UTF-8";

    extraLocaleSettings = {
      # Time and date formatting.
      LC_TIME = "ja_JP.UTF-8";
    };

    # Additional locales to support.
    supportedLocales = lib.mkOptionDefault [
      "es_ES.UTF-8/UTF-8" "en_GB.UTF-8/UTF-8"
    ];

  };
}
