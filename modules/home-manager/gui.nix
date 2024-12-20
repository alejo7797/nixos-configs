{ pkgs, lib, myLib, config, ... }: {

  options.myHome.graphical-environment =
    lib.mkEnableOption "the user-level graphical environment";

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
    programs.kitty = {
      enable = true;
      settings = {
        "text_comosition_strategy" = "2.0 0";
        "enable_audio_bell" = "yes";
        "linux_bell_theme" = "ocean";
      };
      extraConfig = lib.mkForce ''
        include ${myLib.dotfiles."kitty/current-theme.conf"}
      '';
    };

  };
}
