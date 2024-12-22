{ pkgs, lib, config, ... }: {

  options.myHome.graphical-environment = lib.mkEnableOption "basic graphical utilities";

  config = lib.mkIf config.myHome.graphical-environment {

    # Enable a few more zsh plugins.
    programs.zsh.oh-my-zsh = {
      plugins = [ "gpg-agent" "zbell" ];
    };

    # Enable the xsettings daemon.
    services.xsettingsd.enable = true;

    # Enable KDE connect.
    services.kdeconnect = {
      enable = true;
      indicator = true;
    };

    # Install and configure kitty.
    myHome.kitty.enable = true;

  };
}
