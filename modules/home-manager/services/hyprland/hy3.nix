{ config, ... }:
let
  stylix-colors = config.lib.stylix.colors;
in
{
  wayland.windowManager.hyprland.settings.plugin.hy3 = {

    tabs = {

      height = 32;
      padding = 0;
      radius = 0;

      text_height = 12;

      text_font = "Noto Sans Medium";

      "col.active" = "0xff${stylix-colors.base00}";
      "col.active.border" = "0xff${stylix-colors.base00}";
      "col.active.text" = "0xff${stylix-colors.base05}";

      "col.inactive" = "0xff${stylix-colors.base00}";
      "col.inactive.border" = "0xff${stylix-colors.base00}";
      "col.inactive.text" = "0xff${stylix-colors.base03}";

      "col.focused" = "0xff${stylix-colors.base00}";
      "col.focused.border" = "0xff${stylix-colors.base00}";
      "col.focused.text" = "0xff${stylix-colors.base03}";

      "col.urgent" = "0xff${stylix-colors.base08}";
      "col.urgent.border" = "0xff${stylix-colors.base08}";
      "col.urgent.text" = "0xff${stylix-colors.base00}";

    };
  };
}
