{ pkgs, lib, config, ... }: {

  options.myHome.firefox.enable = lib.mkEnableOption "firefox configuration";

  config.programs.firefox = lib.mkIf config.myHome.firefox.enable {

    # Enable Firefox configuration.
    enable = true;

    # Handy policies to enable.
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
    };

    # Manage my profile declaratively.
    profiles."${config.home.username}.default" = {

      extensions = with pkgs.nur.repos.rycee.firefox-addons; [
        darkreader
        indie-wiki-buddy
        keepassxc-browser
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

    };

  };
}
