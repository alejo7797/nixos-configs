{ lib, config, ... }: {

  # Set the default locale.
  i18n.defaultLocale = lib.mkDefault "en_US.UTF-8";

  # Provide a generous selection of available locales.
  i18n.supportedLocales = [
    "en_GB.UTF-8/UTF-8"
    "en_US.UTF-8/UTF-8"
    "es_ES.UTF-8/UTF-8"
    "ja_JP.UTF-8/UTF-8"
  ];

}
