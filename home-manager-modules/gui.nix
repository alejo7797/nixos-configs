{ pkgs, lib, config, ... }: {

  options.myHome.graphical-environment = lib.mkEnableOption "the user-level graphical environment";

  config = lib.mkIf config.myHome.graphical-environment {

    # Configure kitty.
    programs.kitty = {
      enable = true;
      settings = {
        "text_comosition_strategy" = "2.0 0";
        "enable_audio_bell" = "yes";
        "linux_bell_theme" = "ocean";
      };
    };

  };

}
