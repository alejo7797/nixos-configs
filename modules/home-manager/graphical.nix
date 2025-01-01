{ pkgs, lib, config, ... }: {

  options.myHome.graphical.enable = lib.mkEnableOption "basic graphical utilities";

  config = lib.mkIf config.myHome.graphical.enable {

    programs.zsh = {

      # Define a few more aliases.
      shellAliases = let
        variety = "${pkgs.variety}/bin/variety";
      in {
        # Interact with Variety.
        bgnext  = "${variety} --next";
        bgprev  = "${variety} --previous";
        bgtrash = "${variety} --trash";
        bgfav   = "${variety} --favorite";
      };

    };

    # Enable the xsettings daemon.
    services.xsettingsd.enable = true;

    # Start KDE connect as a user service.
    services.kdeconnect = {
      enable = true;
      indicator = true;
    };

    # Custom variety wallpaper script.
    xdg.configFile."variety/scripts/set_wallpaper".source = ./variety/set_wallpaper;

    # Install and configure kitty.
    myHome.kitty.enable = true;

    # Configure Firefox.
    myHome.firefox.enable = true;

    # XDG autostart.
    myHome.xdgAutostart = with pkgs; [

      firefox thunderbird variety

      # We need to specify the .desktop file manually.
      (keepassxc // { desktopFile = "org.keepassxc.KeePassXC.desktop"; })

    ];
  };
}
