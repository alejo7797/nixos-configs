{ config, lib, ... }: {

  programs.hyprlock.settings = {

    general = {
      grace = 5; hide_cursor = true;
    };

    background = {
      path = lib.mkDefault "${config.xdg.stateHome}/wall.jpg";
      blur_passes = 2; brightness = 0.5;
    };

    input-field = {
      fade_timeout = 1000; monitor = "";
      placeholder_text = ""; size = "400, 60";
    };

    };

}
