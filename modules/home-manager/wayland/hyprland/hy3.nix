{ pkgs, lib, config, ... }: {

  # Configure hy3.
  wayland.windowManager.hyprland.settings.plugin.hy3 = {

    # Create a tab group for the first window in a workspace.
    tab_first_window = true;

    # Tab group settings.
    tabs = {
      height = 30;
      padding = 0;
      rounding = 0;
      text_height = 12;
      text_padding = 12;

      text_font = "Noto Sans Medium";

      "col.active" = "0xff1d1f21";
      "col.urgent" = "0xffcc6666";
      "col.inactive" = "0xff1d1f21";

      "col.text.active" = "0xffc5c8c6";
      "col.text.urgent" = "0xffc5c8c6";
      "col.text.inactive" = "0xff969896";
    };

  };
}
