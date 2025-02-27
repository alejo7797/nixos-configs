{
  lib,
  inputs,
  osConfig,
  config,
  ...
}:

let
  cfg = config.myHome.firefox;

  # Need to tell the firefox-addons flake.
  system = osConfig.nixpkgs.hostPlatform;
in

{
  options.myHome.firefox.enable = lib.mkEnableOption "Firefox configuration";

  config = lib.mkIf cfg.enable {

    programs.firefox = {
      enable = true;

      # Manage my profile declaratively.
      profiles."${config.home.username}.default" = {

        # Profile-specific extensions.
        extensions = with inputs.firefox-addons.packages.${system}; [

          augmented-steam betterttv
          darkreader simple-tab-groups
          tampermonkey to-google-translate
          yomitan zotero-connector

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
          "browser.startup.page" = 3;

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
          "privacy.sanitize.clearOnShutdown.hasMigratedToNewPrefs2" = true;
          "privacy.clearOnShutdown_v2.historyFormDataAndDownloads" = false;

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
            }
            {
              label = "nextcloud";
              url = "https://cloud.patchoulihq.cc";
              customScreenshotURL = "https://patchoulihq.cc/nextcloud-logo.png";
            }
            {
              label = "arxiv";
              url = "https://arxiv.org/list/math.GT/recent";
              baseDomain = "arxiv.org";
            }
            {
              label = "ae433";
              url = "https://alex.epelde.net/about-to-get-very-silly";
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
            }
          ];
        };
      };
    };
  };
}
