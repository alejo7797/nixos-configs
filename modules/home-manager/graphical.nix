{ pkgs, lib, config, ... }: {

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

    # XDG autostart applications.
    myHome.xdgAutostart = with pkgs; [ firefox ];

    # Enable the xsettings daemon.
    services.xsettingsd.enable = true;

    # Enable the mpris-proxy service.
    services.mpris-proxy.enable = true;

    # Start KDE connect as a user service.
    services.kdeconnect = {
      enable = true;
      indicator = true;
    };

    # Configure additional user services.
    systemd.user.services =

      let
        graphical-service = (
          u: {
            Unit = {
              Description = u.Description;
              PartOf = [ "graphical-session.target" ];
              After = [ "graphical-session-pre.target" ];
            };
            Service = {
              ExecStart = u.ExecStart;
              Restart = "on-failure";
              RestartSec = "800ms";
            };
            Install.WantedBy = [ "graphical-session.target" ];
          }
        );
      in

      {
        # Make xsettingsd more resilient.
        xsettingsd = {
          Service.Restart = lib.mkForce "on-failure";
        };

        # Start polkit-gnome-agent as a user service.
        polkit-gnome-agent = graphical-service {
          Description = "GNOME polkit authentication daemon";
          ExecStart = "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1";
        };

        # Start KeepassXC as a user service.
        keepassxc = graphical-service {
          Description = "KeepassXC password manager";
          ExecStart = "${pkgs.keepassxc}/bin/keepassxc";
        };

        # Start Variety as a user service.
        variety = graphical-service {
          Description = "Variety wallpaper changer";
          ExecStart = "${pkgs.variety}/bin/variety";
        };
      };

    # Include our custom Variety wallpaper script.
    home.activation.variety = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
      cp ${./variety/set_wallpaper} ${config.xdg.configHome}/variety/scripts/set_wallpaper
    '';

  };
}
