{ pkgs, lib, config, ... }: let

  dotfiles = ../../dotfiles;
  lsd = "${pkgs.lsd}/bin/lsd";

in {

  options.myHome.zsh.enable = lib.mkEnableOption "user zsh configuration";

  config = lib.mkIf config.myHome.zsh.enable {

    # Configure zsh.
    programs.zsh = {
      enable = true;

      sessionVariables = {

        # Configure OhMyZsh.
        DISABLE_AUTO_TITLE="true";
        ENABLE_CORRECTION = "true";
        COMPLETION_WAITING_DOTS = "true";
        HIST_STAMPS = "yyyy-mm-dd";

      };

      # Configure some useful aliases.
      shellAliases = {

        # https://github.com/lsd-rs/lsd
        ls = "${lsd}";

        l = "ls -l"; lt = "ls --tree";
        la = "ls -a"; lla = "ls -la";

        su = "${pkgs.sudo}/bin/sudo -i";
        ps = "${pkgs.procps}/bin/ps -ef";

        dmesg = lib.concatStringsSep " " [
          "${pkgs.sudo}/bin/sudo"
          "${pkgs.util-linux}/bin/dmesg"
          "-H -e --color=always"
          "| ${pkgs.less}/bin/less"
        ];

      };

      initExtraFirst = ''
        # Enable Powerlevel10k instant prompt.
        if [[ -r "$XDG_CACHE_HOME/p10k-instant-prompt-''${(%):-%n}.zsh" ]]; then
          source "$XDG_CACHE_HOME/p10k-instant-prompt-''${(%):-%n}.zsh"
        fi
      '';

      initExtra = ''
        # Allow quitting zsh mid-command
        exit_zsh() { exit }
        zle -N exit_zsh
        bindkey '^D' exit_zsh
      '';

      # Use OhMyZsh to load useful plugins.
      oh-my-zsh = {
        enable = true;

        plugins = [
          "alias-finder" "dirhistory" "git"
          "git-auto-fetch" "history" "python"
          "rsync" "safe-paste" "sudo" "systemd"
        ];

        extraConfig = ''

          # Suppress notifications
          zbell_ignore=( dotfiles nix-shell git
                         htop less man powertop
                         ssh su vim vimdiff )

          # Help us learn aliases
          zstyle ':omz:plugins:alias-finder' autoload yes
          zstyle ':omz:plugins:alias-finder' exact yes
          zstyle ':omz:plugins:alias-finder' cheaper yes

        '';
      };

      # Load additional plugins.
      plugins = [
        {
          name = "nix-shell";
          src = "${pkgs.zsh-nix-shell}/share/zsh-nix-shell";
        }
        {
          name = "powerlevel10k";
          src = "${pkgs.zsh-powerlevel10k}";
          file = "share/zsh-powerlevel10k/powerlevel10k.zsh-theme";
        }
        {
          name = "powerlevel10k-config";
          src = "${dotfiles}/zsh";
          file = "p10k.zsh";
        }
      ];

    };
  };
}
