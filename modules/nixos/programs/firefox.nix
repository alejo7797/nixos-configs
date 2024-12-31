{ pkgs, lib, config, ... }: {

  options.myNixOS.firefox.enable = lib.mkEnableOption "Firefox";

  config = lib.mkIf config.myNixOS.firefox.enable {

    # Install and configure Firefox.
    programs.firefox = {
      enable = true;

      # Useful policies to enable.
      policies = {
        "DisableFeedbackCommands" = true;
        "DisableFirefoxStudies" = true;
        "DisablePocket" = true;
        "DisableSetDesktopBackground" = true;
        "DisableTelemetry" = true;

        "Extensions" = {
          "Install" = [
            "https://addons.mozilla.org/firefox/downloads/latest/ublock-origin/latest.xpi"
          ];
        };

        "Preferences" = let
          lock-false = { Value = false; Status = "locked"; };
        in {
          "browser.newtabpage.activity-stream.showSponsored" = lock-false;
          "browser.newtabpage.activity-stream.showSponsoredTopSites" = lock-false;
          "browser.newtabpage.activity-stream.feeds.section.topstories" = lock-false;
        };
      };
    };

    environment.variables.BROSWER = "firefox";

  };
}
