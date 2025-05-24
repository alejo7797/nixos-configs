{ config, pkgs, ... }:

{
  programs.firefox = {

    # Manage a Firefox user profile declaratively.
    profiles."${config.home.username}.default" = {

      # Some extensions to install by default.
      extensions = with pkgs.firefox-addons; [

        augmented-steam
        aw-watcher-web
        betterttv
        darkreader
        image-search-options
        simple-tab-groups
        tampermonkey
        to-google-translate
        wayback-machine
        yomitan
        zotero-connector

      ];

      settings = {
        # Restore previous session.
        "browser.startup.page" = 3;

        # Always ask where to save downloaded files.
        "browser.download.useDownloadDir" = false;

        "extensions.formautofill.addresses.enabled" = false;
        "signon.rememberSignons" = false; # Don't offer to save.
        "extensions.formautofill.creditCards.enabled" = false;

        # We enable a few strict privacy settings.
        "browser.contentblocking.category" = "strict";
        "privacy.globalprivacycontrol.enabled" = true;
        "privacy.fingerprintingProtection" = true;

        # Enable HTTPS-only mode by default.
        "dom.security.https_only_mode" = true;

        # For DRM-controlled content.
        "media.eme.enabled" = true;

        # Custom history-related config.
        "privacy.history.custom" = true;

        "privacy.sanitize.sanitizeOnShutdown" = true; # We clear cookies.
        "privacy.sanitize.clearOnShutdown.hasMigratedToNewPrefs2" = true;
        "privacy.clearOnShutdown_v2.historyFormDataAndDownloads" = false;
      };

    };

  };
}
