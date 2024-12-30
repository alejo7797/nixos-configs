{ pkgs, lib, config, ... }: {

  options.myHome.joplin-desktop.enable = lib.mkEnableOption "joplin-desktop";

  config = lib.mkIf config.myHome.joplin-desktop.enable {

    programs.joplin-desktop = {

      # Install joplin-desktop.
      enable = true;

      # Configure joplin-desktop.
      extraConfig = {

        # Basic settings.
	"locale" = "en_US";
	"dateFormat" = "YYYY-MM-DD";
	"themeAutoDetect" = true;
	"notes.sortOrder.field" = "title";

        # Font configuration.
	"style.editor.fontSize" = 14;
	"style.editor.fontFamily" = "Noto Sans CJK JP";
	"style.editor.monospaceFontFamily" = "Hack Nerd Font Mono";

        # Sync to my Nextcloud instance.
        "sync.target" = 5;
	"sync.5.path" = "https://cloud.patchoulihq.cc/remote.php/dav/files/ewan/joplin";
	"sync.5.username" = "ewan";

      };
    };

    # Style the interface.
    xdg.configFile = {
      "joplin-desktop/userchrome.css".source = ./userchrome.css;
      "joplin-desktop/userstyle.css".source = ./userstyle.css;
    };

    # Fix the application icon.
    xdg.dataFile = {
      "icons/Papirus-Dark/32x32/apps/@joplinapp-desktop.svg".source =
        "${pkgs.papirus-icon-theme}/share/icons/Papirus-Dark/32x32/apps/joplin.svg";
    };

  };
}
