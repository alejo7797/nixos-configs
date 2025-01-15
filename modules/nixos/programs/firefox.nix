{
  lib,
  config,
  ...
}:

let
  cfg = config.myNixOS.firefox;
in

{
  options.myNixOS.firefox.enable = lib.mkEnableOption "Firefox";

  config = lib.mkIf cfg.enable {

    programs.firefox = {
      enable = true;

      policies = {

        # Essential policies.
        "DisableFeedbackCommands" = true;
        "DisableFirefoxStudies" = true;
        "DisablePocket" = true;
        "DisableSetDesktopBackground" = true;
        "DisableTelemetry" = true;

        # Essential Firefox addons.
        Extensions.Install =
          map (a: "https://addons.mozilla.org/firefox/downloads/latest/${a}/latest.xpi")
            [
              "canvasblocker" "decentraleyes" "facebook-container"
              "font-fingerprint-defender" "h264ify" "indie-wiki-buddy"
              "keepassxc-browser" "privacy-badger17"
              "ublock-origin" "youtube-shorts-block"
            ];

        Preferences =
          let
            lock-false = { Value = false; Status = "locked"; };
          in
          {
            # Disable sponsored content.
            "browser.newtabpage.activity-stream.showSponsored" = lock-false;
            "browser.newtabpage.activity-stream.showSponsoredTopSites" = lock-false;
            "browser.newtabpage.activity-stream.feeds.section.topstories" = lock-false;
          };

      };
    };

    environment.variables.BROSWER = "firefox";
  };
}
