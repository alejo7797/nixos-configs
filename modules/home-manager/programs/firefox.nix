{ pkgs, lib, config, ... }: {

  options.myHome.firefox.enable = lib.mkEnableOption "firefox profile configuration";

  config.programs.firefox = lib.mkIf config.myHome.firefox.enable {

    # Enable Firefox configuration.
    enable = true;

    # Manage my profile declaratively.
    profiles."${config.home.username}.default" = {

      extensions = with pkgs.nur.repos.rycee.firefox-addons; [
        augmented-steam
        betterttv
        canvasblocker
        darkreader
        decentraleyes
        facebook-container
        h264ify
        indie-wiki-buddy
        keepassxc-browser
        privacy-badger
        return-youtube-dislikes
        simple-tab-groups
        tampermonkey
        to-google-translate
        user-agent-string-switcher
        yomitan
        youtube-shorts-block
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
            "id"="shutdown";
            "itemsToClear" = [ "cache" "cookiesAndStorage" ];
            "options" ={};
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
          }
          {
            label = "nextcloud";
            url = "https://cloud.patchoulihq.cc";
          }
          {
            label = "arxiv";
            url = "https://arxiv.org/list/math.GT/recent";
          }
          {
            label = "ae433";
            url = "https://ae433.user.srcf.net/about-to-get-very-silly";
          }
          {
            label = "archwiki";
            url = "https://wiki.archlinux.org";
            customScreenshotURL = "https://img.icons8.com/color/480/arch-linux.png";
          }
          {
            label = "patreon";
            url = "https://www.patreon.com";
          }
        ];
      };
    };
  };
}
