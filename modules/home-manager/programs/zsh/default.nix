{ config, lib, pkgs, ... }: {

  programs.direnv = {
    # We need to do this manually!
    enableZshIntegration = false;
  };

  programs.zsh = {
    autocd = true;

    dotDir = ".config/zsh";

    history.path = "${config.xdg.stateHome}/zsh/history";

    sessionVariables = {
      # OhMyZsh configuration.
      DISABLE_AUTO_TITLE = "true";
      ENABLE_CORRECTION = "true";
      HIST_STAMPS = "yyyy-mm-dd";
    };

    initExtraFirst =

      lib.optionalString config.programs.direnv.enable ''
        emulate zsh -c "$(direnv export zsh)"
      ''
      +
      ''
      if [[ -r "$XDG_CACHE_HOME/p10k-instant-prompt-''${(%):-%n}.zsh" ]]; then
        source "$XDG_CACHE_HOME/p10k-instant-prompt-''${(%):-%n}.zsh"
      fi
      ''
      +
      lib.optionalString config.programs.direnv.enable ''
      emulate zsh -c "$(direnv hook zsh)"
    '';

    initExtra = ''
      # Accept suggestion with Shift+Tab.
      bindkey '^[[Z' autosuggest-accept

      # See OhMyZsh.
      unalias gap
    '';

    oh-my-zsh = {
      enable = true;

      plugins = [
        "alias-finder" "dirhistory"
        "git" "history" "python"
        "rsync" "ruby" "safe-paste"
        "sudo" "systemd" "zbell"
      ];

      extraConfig = ''
        zstyle ':omz:plugins:alias-finder' autoload yes
        zstyle ':omz:plugins:alias-finder' exact yes
        zstyle ':omz:plugins:alias-finder' cheaper yes

        zbell_ignore=(
          bash dmesg nix-shell
          git htop journalctl
          less man sc-status
          scu-status ssh vim
        )
      '';
    };

    plugins =

      let
        p10k-config = patch: pkgs.stdenv.mkDerivation {
          name = "p10k.zsh";
          src = pkgs.zsh-powerlevel10k;
          patches = [ patch ];
          dontBuild = true;

          installPhase = ''
            install -Dm644 share/zsh-powerlevel10k/config/p10k-lean-8colors.zsh $out/p10k.zsh
          '';
        };
      in

      [
        {
          name = "nix-shell"; # Use Zsh under nix-shell.
          src = "${pkgs.zsh-nix-shell}/share/zsh-nix-shell";
        }
        {
          name = "powerlevel10k"; src = "${pkgs.zsh-powerlevel10k}";
          file = "share/zsh-powerlevel10k/powerlevel10k.zsh-theme";
        }
        {
          name = "powerlevel10k-config";
          # Default configuration for our Zsh theme.
          src = p10k-config ./powerlevel10k/p10k.patch;
          file = "p10k.zsh";
        }
        {
          name = "powerlevel10k-config-tty";
          # TTY-friendly configuration for our Zsh theme.
          src = p10k-config ./powerlevel10k/p10k-tty.patch;
          file = "p10k.zsh";
        }
      ];

  };

  home.file.".zshenv".enable = false;
}
