{ pkgs, lib, config, ... }: {

  options.myHome.joplin-desktop.enable = lib.mkEnableOption "joplin-desktop";

  config = lib.mkIf config.myHome.joplin-desktop.enable {

    # Install and configure joplin-desktop.
    programs.joplin-desktop = {
      enable = true;

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

    # Ugly fix for autostarting joplin-desktop under XWayland.
    wayland.windowManager =
      let
        uwsm-app = "${pkgs.uwsm}/bin/uwsm app";
        joplin-desktop = "NIXOS_OZONE_WL= ${uwsm-app} -- joplin-desktop";
      in
      {
        sway.config.startup = [ { command = "${joplin-desktop}"; } ];
        hyprland.settings.exec-once = [ "${joplin-desktop}" ];
      };

  };
}
