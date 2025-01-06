{ pkgs, lib, config, ... }: let

  cfg = config.myHome.firefox;

in {

  options.myHome.firefox.enable = lib.mkEnableOption "firefox profile configuration";

  config.programs.firefox = lib.mkIf cfg.enable {

    # Enable Firefox configuration.
    enable = true;

    # Manage my profile declaratively.
    profiles."${config.home.username}.default" = {

      # Profile-specific extensions.
      extensions = with pkgs.nur.repos.rycee.firefox-addons; [
        augmented-steam
        betterttv
        darkreader
        simple-tab-groups
        tampermonkey
        yomitan
        zotero-connector
      ];

      search = {
        default = "DuckDuckGo";
        force = true;
        engines = {
          "Bing".metaData.hidden = true;
          "Google".metaData.hidden = true;
        };
      };

      settings = {
        # Restore previous session.
        "broswer.startup.page" = 3;

        # Always ask where to save downloaded files.
        "browser.download.useDownloadDir" = false;

        # Do not ask to save passwords or addresses.
        "signon.rememberSignons" = false;
        "extensions.formautofill.addresses.enabled" = false;
        "extensions.formautofill.creditCards.enabled" = false;

        # Privacy settings.
        "browser.contentblocking.category" = "strict";
        "privacy.donottrackheader.enabled" = true;
        "privacy.fingerprintingProtection" = true;
        "privacy.globalprivacycontrol.enabled" = true;

        # HTTPS-only mode.
        "dom.security.https_only_mode" = true;

        # Play DRM-controlled content.
        "media.eme.enabled" = true;

        # Clear cookies on browser shutdown.
        "privacy.history.custom" = true;
        "privacy.sanitize.sanitizeOnShutdown" = true;
        "privacy.sanitize.pending" = [
          {
            "id" = "shutdown";
            "itemsToClear" = [ "cache" "cookiesAndStorage" ];
            "options" = { };
          }
        ];

        # Pinned sites.
        "browser.newtabpage.pinned" = [
          {
            label = "youtube";
            url = "https://www.youtube.com";
          }
          {
            label = "wanikani";
            url = "https://www.wanikani.com";
          }
          {
            label = "patchouli";
            url = "https://patchoulihq.cc";
            baseDomain = "patchoulihq.cc";
          }
          {
            label = "nextcloud";
            url = "https://cloud.patchoulihq.cc";
          }
          {
            label = "arxiv";
            url = "https://arxiv.org/list/math.GT/recent";
            baseDomain = "arxiv.org";
          }
          {
            label = "ae433";
            url = "https://ae433.user.srcf.net/about-to-get-very-silly";
            baseDomain = "ae433.user.srcf.net";
          }
          {
            label = "nixos";
            url = "https://search.nixos.org";
            customScreenshotURL = "https://patchoulihq.cc/nix-logo.png";
          }
          {
            label = "patreon";
            url = "https://www.patreon.com";
            baseDomain = "patreon.com";
          }
        ];
      };
    };
  };
}
