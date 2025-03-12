{
  lib,
  config,
  pkgs,
  ...
}:

let
  cfg = config.myHome.zsh;
in

{
  options.myHome.zsh.enable = lib.mkEnableOption "Zsh configuration";

  config = lib.mkIf cfg.enable {

    programs.direnv = {
      enable = true;

      # Improved implementation.
      nix-direnv.enable = true;

      # We need to do this manually!
      enableZshIntegration = false;
    };

    programs.zsh = {
      enable = true;
      autocd = true;

      dotDir = ".config/zsh";

      history.path = "${config.xdg.stateHome}/zsh/history";

      sessionVariables = {
        # OhMyZsh configuration.
        DISABLE_AUTO_TITLE = "true";
        ENABLE_CORRECTION = "true";
        HIST_STAMPS = "yyyy-mm-dd";
      };

      shellAliases = {
        # See github.com/lsd-rs/lsd.
        ls = "lsd \${=lsd_params}";

        # Quite standard ls aliases.
        l = "ls -l"; lt = "ls --tree";
        la = "ls -a"; lla = "ls -la";

        # Handy aliases for building NixOS configurations from my flake.
        nixos-switch = "sudo nixos-rebuild switch --flake ~/Git/nixos-configs";
        nixos-build = "nixos-rebuild build --flake ~/Git/nixos-configs";

        # Manage connection to my VPN server.
        vpnup = "nmcli c up Koakuma_VPN";
        vpndown = "nmcli c down Koakuma_VPN";

        # Normal syntax.
        ps = "ps -ef";

        # Make dmesg output more readable and friendly.
        dmesg = "sudo dmesg -H -e --color=always | less";
      };

      initExtraFirst = ''
        emulate zsh -c "$(direnv export zsh)"

        if [[ -r "$XDG_CACHE_HOME/p10k-instant-prompt-''${(%):-%n}.zsh" ]]; then
          source "$XDG_CACHE_HOME/p10k-instant-prompt-''${(%):-%n}.zsh"
        fi

        emulate zsh -c "$(direnv hook zsh)"
      '';

      initExtra = ''
        # Accept suggestion with Shift+Tab.
        bindkey '^[[Z' autosuggest-accept

        if (( terminfo[colors] == 8 )); then
          # Don't show icons in TTY.
          lsd_params="--icon never"
        fi

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
            dotfiles nix-shell git
            htop less man powertop
            ssh su vim vimdiff
          )
        '';
      };

      plugins = [
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
          src = ./powerlevel10k; file = "p10k.zsh";
        }
        {
          name = "powerlevel10k-config";
          # TTY-friendly configuration for our Zsh theme.
          src = ./powerlevel10k; file = "p10k-tty.zsh";
        }
      ];

    };

    home.file.".zshenv".enable = false;

    xdg.configFile = {
      # Configure lsd, for a happier ls experience.
      "lsd/config.yaml".source = ./lsd-config.yaml;
    };
  };
}
