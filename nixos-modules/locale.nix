{ lib, config, ... }: {

options.myNixOS.iso-time-format.enable = lib.mkEnableOption "the ISO 8601 date-time format";

  config = {

    # Configure the locale.
    i18n.defaultLocale = lib.mkDefault "en_US.UTF-8";

    # A generous selection of available locales.
    i18n.supportedLocales = [
      "en_DK.UTF-8/UTF-8"
      "en_GB.UTF-8/UTF-8"
      "en_US.UTF-8/UTF-8"
      "es_ES.UTF-8/UTF-8"
      "ja_JP.UTF-8/UTF-8"
    ];

    i18n.extraLocaleSettings =
      # And optionally, use the ISO date-time format.
      lib.mkIf config.myNixOS.iso-time-format.enable {
        LC_TIME = "en_DK.UTF-8";
      };

  };

}
