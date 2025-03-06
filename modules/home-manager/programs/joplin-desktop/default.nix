{ lib, config, ... }:

let
  cfg = config.my.joplin;
in

{
  options.my.joplin.enable = lib.mkEnableOption "Joplin";

  config = lib.mkIf cfg.enable {

    # Install and configure joplin-desktop.
    programs.joplin-desktop = {
      enable = true;

      extraConfig = {
        # Basic settings.
        "locale" = "en_US";
        "dateFormat" = "YYYY-MM-DD";
	      "editor.codeView" = true;
        "themeAutoDetect" = true;
        "notes.sortOrder.field" = "title";
      	"notes.sortOrder.reverse" = false;

        # Font configuration.
        "style.editor.fontSize" = 14;
        "style.editor.fontFamily" = "Noto Sans CJK JP";
        "style.editor.monospaceFontFamily" = "Hack Nerd Font Mono";
      };
    };

    # Style the interface.
    xdg.configFile = {
      "joplin-desktop/userchrome.css".source = ./userchrome.css;
      "joplin-desktop/userstyle.css".source = ./userstyle.css;
    };
  };
}
