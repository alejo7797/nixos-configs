{ pkgs, lib, myLib, config, ... }: {

  options.myHome.zsh.enable = lib.mkEnableOption "zsh configuration";

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
        ls = "${pkgs.lsd}/bin/lsd \${=lsd_params}";

        l = "ls -l"; lt = "ls --tree";
        la = "ls -a"; lla = "ls -la";

        su = "sudo -i";

        # Use standard syntax.
        ps = "${pkgs.procps}/bin/ps -ef";

        # Pretty dmesg output.
        dmesg = lib.concatStringsSep " " [
          "sudo ${pkgs.util-linux}/bin/dmesg"
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

        # Accept autosuggestion with Shift+Tab
        bindkey '^[[Z' autosuggest-accept

        # Compatibility mode for lsd.
        if (( terminfo[colors] == 8 )); then
          lsd_params="--icon never"
        fi

        # Allow quitting zsh mid-command.
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
      plugins = with myLib; [
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
          src = dotfiles."zsh/powerlevel10k";
          file = "p10k.zsh";
        }
        {
          name = "powerlevel10k-config";
          src = dotfiles."zsh/powerlevel10k";
          file = "p10k-portable.zsh";
        }
      ];

    };

    xdg.configFile = with myLib; {
      # Configure lsd, the next-gen ls command.
      "lsd/config.yaml".source = dotfiles."zsh/lsd-config.yaml";
    };

  };
}
