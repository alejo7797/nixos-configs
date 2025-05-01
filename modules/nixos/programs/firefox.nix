{ lib, ... }: {

  programs.firefox = {

    # Our preferred language selection.
    languagePacks = [ "en-GB" "es-ES" ];

    policies = {

      # Disable menus for site reports.
      DisableFeedbackCommands = true;

      # Don't mess with my install.
      DisableFirefoxStudies = true;

      # Advertising, please.
      DisablePocket = true;

      # No "Set As Desktop Background".
      DisableSetDesktopBackground = true;

      # An increased privacy.
      DisableTelemetry = true;

      # Declarative addon installation.
      ExtensionSettings = lib.mapAttrs

        (
          name: extension_config: {
            install_url = "https://addons.mozilla.org/firefox/downloads/latest/${name}/latest.xpi";
            installation_mode = "normal_installed"; inherit (extension_config) private_browsing;
          }
        )

        (lib.mapAttrs (_: _: { private_browsing = true; }) {

          canvasblocker = { }; # Spoofing.
          font-fingerprint-defender = { };

          decentraleyes = { };
          facebook-container = { };
          privacy-badger17 = { };

          # Block advertising.
          ublock-origin = { };

        }) // {

          # ¡Anda, mira! Una « ñ » en la URL.
          "diccionario-de-español-españa" = { };
          "british-english-dictionary-2" = { };

          # Video stuff.
          h264ify = { };

          # Avoid Fandom wikis.
          indie-wiki-buddy = { };

          # Use a password manager.
          keepassxc-browser = { };

          # Make shorts play normally.
          youtube-shorts-block = { };

        };

      FirefoxHome = {
        Pocket = false; # Remove some stuff from the homepage.
        SponsoredPocket = false; SponsoredTopSites = false;
      };

    };

  };
}
