{ pkgs, lib, config, ... }: {

  # Configure hy3.
  wayland.windowManager.hyprland.settings.plugin.hy3 = {

    # Create a tab group for the first window in a workspace.
    tab_first_window = true;

    # Tab group settings.
    tabs = {
      height = 30;
      padding = 0;
      text_height = 12;
      text_padding = 6;
    };

  };
}
