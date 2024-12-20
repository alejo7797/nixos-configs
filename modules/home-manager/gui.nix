{ pkgs, lib, config, ... }: {

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

    # Enable and configure Gammastep.
    services.gammastep = {
      enable = true;
      tray = true;
      provider = "geoclue2";
      settings.general = {
        fade = 1;
        gamma = 0.8;
        adjustment-method =
          lib.mkDefault "randr";
      };
    };

    # Install and configure kitty.
    programs.kitty = {
      enable = true;
      settings = {
        "text_comosition_strategy" = "2.0 0";
        "enable_audio_bell" = "yes";
        "linux_bell_theme" = "ocean";
      };
    };

  };
}
