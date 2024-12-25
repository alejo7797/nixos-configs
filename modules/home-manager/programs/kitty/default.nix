{ pkgs, lib, config, ... }: {

  options.myHome.kitty.enable = lib.mkEnableOption "kitty";

  config = lib.mkIf config.myHome.kitty.enable {

    # Install and configure kitty.
    programs.kitty = {
      enable = true;
      settings = {
        "text_composition_strategy" = "2.0 0";
        "enable_audio_bell" = "yes";
        "linux_bell_theme" = "ocean";
      };
      extraConfig = ''
        include current-theme.conf
      '';
    };

    # Set the color theme ourselves.
      stylix.targets.kitty.enable = false;

    xdg.configFile = {
      # Patched to have correct selection colors.
      "kitty/current-theme.conf".source = ./current-theme.conf;
    };

  };
}
