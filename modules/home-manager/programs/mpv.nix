{ pkgs, ... }: {

  programs.mpv = {

    config = {
      # Resume from last position.
      save-position-on-quit = true;

      # GPU acceleration.
      profile = "gpu-hq";
    };

    # Automatically queue files in the directory.
    scripts = with pkgs.mpvScripts; [ autoload ];

  };

}
