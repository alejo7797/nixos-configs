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

        # Ask where to save downloaded files.
        "browser.download.useDownloadDir" = false;

        # Do not ask to save passwords.
        "signon.rememberSignons" = false;

        # Privacy settings.
        "privacy.donottrackheader.enabled" = true;
        "privacy.fingerprintingProtection" = true;
        "privacy.globalprivacycontrol.enabled" = true;

        # Pinned sites.
        "browser.newtabpage.pinned" = [
          {
            label = "youtube";
            url = "https://youtube.com";
          }
          {
            label = "wanikani";
            url = "https://wanikani.com";
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
            url = "https://patreon.com";
          }
        ];
      };
    };
  };
}
