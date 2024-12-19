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
          "alias-finder" "git" "git-auto-fetch"
          "history" "python" "rsync" "safe-paste"
          "sudo" "systemd" "zbell"
        ];
      };

      # Load additional plugins.
      plugins = [
        {
          name = "nix-shell";
          src = "${pkgs.zsh-nix-shell}/share/zsh-nix-shell";
        }
        {
          name = "powerlevel10k";
          src = pkgs.zsh-powerlevel10k;
          file = "share/zsh-powerlevel10k/powerlevel10k.zsh-theme";
        }
      ];

    };

  };

}
