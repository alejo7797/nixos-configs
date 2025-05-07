{ config, pkgs, ... }:

let
  inherit (config.xdg) configHome;
in

{
  services.activitywatch = {

    settings = {
      # The default server configuration.
      address = "127.0.0.1"; port = 5600;
    };

    watchers = {

      # For improved Wayland support.
      awatcher = { config, ... }: {

        package = pkgs.awatcher;

        extraOptions = [
          "--config" # By default, awatcher looks for the configuration elsewhere.
          "${configHome}/activitywatch/${config.name}/${config.settingsFilename}"
        ];

        settings = {

          awatcher.filters = [
            {
              match-app-id = "kitty"; # Report a more friendly window title for toggleterm.
              match-title = "zsh;#toggleterm#\\d+ - \\(term:\\/\\/(.*)\\/\\/\\d+:.*\\) - NVIM";
              replace-title = "toggleterm.nvim - $1 - NVIM"; replace-app-id = "neovim";
            }
            {
              match-app-id = "kitty"; # Keep window title stable.
              match-title = "(.*[^+]) (?:\\+ )?(\\(.*\\) - NVIM)";
              replace-app-id = "neovim"; replace-title = "$1 $2";
            }
            {
              match-app-id = "org\\.kde\\.dolphin";
              replace-app-id = "dolphin"; # Shorten.
            }
            {
              match-app-id = "org\\.keepassxc\\.KeePassXC";
              replace-app-id = "keepassxc"; # Just the same.
            }
            {
              match-app-id = "org\\.pwmt\\.zathura";
              replace-app-id = "zathura"; # Again.
            }
            {
              match-app-id = "com\\.github\\.iwalton3\\.jellyfin-media-player";
              replace-app-id = "jellyfin-media-player"; # And another app id.
            }
          ];

        };

      };

    };
  };
}
