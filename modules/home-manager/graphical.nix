{ pkgs, lib, config, ... }: {

  imports = [
    ./i3-wm.nix ./wayland ./style
    ./autostart.nix ./mime.nix
  ];

  options.myHome.graphical.enable = lib.mkEnableOption "basic graphical utilities";

  config = lib.mkIf config.myHome.graphical.enable {

    # Define a few more shell aliases.
    programs.zsh.shellAliases =
      let
        variety = "${pkgs.variety}/bin/variety";
      in
      {
        # Interact with Variety.
        bgnext  = "${variety} --next";
        bgprev  = "${variety} --previous";
        bgtrash = "${variety} --trash";
        bgfav   = "${variety} --favorite";
      };

    # Install and configure kitty.
    myHome.kitty.enable = true;

    # Configure Firefox.
    myHome.firefox.enable = true;

    # Enable the xsettings daemon.
    services.xsettingsd.enable = true;

    # Enable the mpris-proxy service.
    services.mpris-proxy.enable = true;

    # Start KDE connect as a user service.
    services.kdeconnect = {
      enable = true;
      indicator = true;
    };

    # Configure Fcitx5.
    xdg.configFile."fcitx5" = {
      source = ./fcitx5/config;
      force = true;
      recursive = true;
    };
    xdg.dataFile."fcitx5" = {
      source = ./fcitx5/data;
      recursive = true;
    };

    # Explicitly disable Baloo.
    xdg.configFile."baloofilerc".text = ''
      [Basic Settings]
      Indexing-Enabled=false
    '';

    # Configure additional user services.
    systemd.user.services =

      let graphical-service = (
        service:
          {
            Unit.PartOf = [ "graphical-session.target" ];
            Install.WantedBy = [ "graphical-session.target" ];
          }
          // service
        );
      in

      # Satsuki is not ready for this yet.
      lib.mkIf (config.myHome.hostname != "satsuki")

      {
        # Start polkit-gnome-agent as a user service.
        polkit-gnome-agent = graphical-service {
          Unit.Description = "GNOME PolicyKit authentication daemon";
          Service.ExecStart = "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1";
        };

        # Start KeepassXC as a user service.
        keepassxc = graphical-service {
          Unit.Description = "KeepassXC password manager";
          # Prevent quirks with KeepassXC when it starts too early.
          Service.ExecStartPre = "${pkgs.coreutils}/bin/sleep 5";
          Service.ExecStart = "${pkgs.keepassxc}/bin/keepassxc";
        };

        # Start Variety as a user service.
        variety = graphical-service {
          Unit.Description = "Variety wallpaper changer";
          Service.ExecStart = "${pkgs.variety}/bin/variety";
        };
      };

    # Include our custom Variety wallpaper script.
    home.activation.variety = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
      cp ${./variety/set_wallpaper} ${config.xdg.configHome}/variety/scripts/set_wallpaper
    '';

  };
}
