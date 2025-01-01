{ pkgs, lib, config, ... }: {

  # Configure hy3.
  wayland.windowManager.hyprland.settings.plugin.hy3 = {

    # Create a tab group for the first window in a workspace.
    tab_first_window = true;

  };
}
