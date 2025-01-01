{ pkgs, lib, config, ... }: {

  options.myHome.graphical.enable = lib.mkEnableOption "basic graphical utilities";

  config = lib.mkIf config.myHome.graphical.enable {

    programs.zsh = {

      # Define a few more aliases.
      shellAliases =
        let
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

    # Enable the mpris-proxy service.
    services.mpris-proxy.enable = true;

    # Start KDE connect as a user service.
    services.kdeconnect = {
      enable = true;
      indicator = true;
    };

    # Install and configure kitty.
    myHome.kitty.enable = true;

    # Configure Firefox.
    myHome.firefox.enable = true;

    # Custom variety wallpaper script.
    home.activation.variety = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
      cp ${./variety/set_wallpaper} ${config.xdg.configHome}/variety/scripts/set_wallpaper
    '';

    # XDG autostart.
    myHome.xdgAutostart = with pkgs; [

      firefox thunderbird variety

      # We need to specify the .desktop file manually.
      (keepassxc // { desktopFile = "org.keepassxc.KeePassXC.desktop"; })

    ];
  };
}
