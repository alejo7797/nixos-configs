{ pkgs, lib, config, ... }: {

  options.myHome.zsh.enable = lib.mkEnableOption "user zsh configuration";

  config = lib.mkIf config.myHome.zsh.enable {

    # Configure zsh.
    programs.zsh = {
      enable = true;

      # Use OhMyZsh to load useful plugins.
      oh-my-zsh = {
        enable = true;
        plugins = [
          "aliases" "git" "git-auto-fetch" "history"
          "python" "rsync" "safe-paste" "systemd"
        ];
      };

      # Load additional plugins.
      plugins = [];

    };

  };

}
