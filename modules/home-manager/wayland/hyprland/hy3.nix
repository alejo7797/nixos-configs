{ config, ... }:
let
  stylix-colors = config.lib.stylix.colors;
in
{
  wayland.windowManager.hyprland.settings.plugin.hy3 = {

    tab_first_window = true;

    tabs = {
      height = 30;
      padding = 0;
      rounding = 0;
      text_height = 12;
      text_padding = 12;

      text_font = "Noto Sans Medium";

      "col.active" = "0xff${stylix-colors.base00}";
      "col.urgent" = "0xff${stylix-colors.base08}";
      "col.inactive" = "0xff${stylix-colors.base00}";

      "col.text.active" = "0xff${stylix-colors.base05}";
      "col.text.urgent" = "0xff${stylix-colors.base00}";
      "col.text.inactive" = "0xff${stylix-colors.base03}";
    };
  };
}
