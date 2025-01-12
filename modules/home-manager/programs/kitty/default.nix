{
  lib,
  config,
  ...
}:

let
  cfg = config.myHome.kitty;
in

{
  options.myHome.kitty.enable = lib.mkEnableOption "kitty";

  config = lib.mkIf cfg.enable {

    # Install and configure kitty.
    programs.kitty = {
      enable = true;
      settings = {
        "font_family" = "Hack Nerd Font";
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
