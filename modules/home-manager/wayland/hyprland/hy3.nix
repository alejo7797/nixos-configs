{ pkgs, lib, config, ... }: {

  # Configure hy3.
  wayland.windowManager.hyprland.settings.plugin.hy3 = {

    # Create a tab group for the first window in a workspace.
    tab_first_window = true;

    # Tab group settings.
    tabs = {
      height = 24;
      padding = 0;
      rounding = 0;
      text_height = 12;
      text_padding = 12;

      "col.active" = "0xff81a2be";
      "col.urgent" = "0xffcc6666";
      "col.inactive" = "0xff282a2e";

      "col.text.active" = "0xff282a2e";
      "col.text.urgent" = "0xff282a2e";
      "col.text.inactive" = "0xffc5c8c6";
    };

  };
}
