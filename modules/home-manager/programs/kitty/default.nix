{ config, lib, ... }:

let
  cfg = config.programs.kitty;
in

{
  config = lib.mkIf cfg.enable {

    programs.kitty = {

      shellIntegration.mode = "no-title";

      settings = {
        # Set desired font appearance for dark background.
        font_family = config.stylix.fonts.monospace.name;
        text_composition_strategy = "2.0 0";

        enable_audio_bell = "yes";
        linux_bell_theme = "ocean";
      };

    };

  };
}
