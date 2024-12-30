{ pkgs, lib, config, ... }: {

  options.myHome.graphical-environment = lib.mkEnableOption "basic graphical utilities";

  config = lib.mkIf config.myHome.graphical-environment {

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

    # Install and configure kitty.
    myHome.kitty.enable = true;

    # XDG autostart.
    myHome.xdgAutostart = with pkgs; [
      firefox thunderbird variety
    ];

  };
}
