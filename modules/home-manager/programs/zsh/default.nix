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
      # We need to do this manually.
      enableZshIntegration = false;
    };

    programs.zsh = {
      enable = true;
      autocd = true;

      sessionVariables = {
        # Configure OhMyZsh.
        DISABLE_AUTO_TITLE = "true";
        ENABLE_CORRECTION = "true";
        COMPLETION_WAITING_DOTS = "true";
        HIST_STAMPS = "yyyy-mm-dd";
      };

      shellAliases = {
        # https://github.com/lsd-rs/lsd
        ls = "lsd \${=lsd_params}";

        l = "ls -l";
        lt = "ls --tree";
        la = "ls -a";
        lla = "ls -la";

        # Build NixOS configuration.
        nixos-build = "nixos-rebuild build --flake ~/Git/nixos-configs";

        # Build and activate NixOS configuration.
        nixos-switch = "sudo nixos-rebuild switch --flake ~/Git/nixos-configs";

        # Manage connection to my VPN server.
        vpnup = "nmcli c up Koakuma_VPN";
        vpndown = "nmcli c down Koakuma_VPN";

        # Use standard syntax.
        ps = "ps -ef";

        # Pretty dmesg output.
        dmesg = "sudo dmesg -H -e --color=always | less";
      };

      initExtraFirst = ''
        emulate zsh -c "$(direnv export zsh)"

        # Enable Powerlevel10k instant prompt.
        if [[ -r "$XDG_CACHE_HOME/p10k-instant-prompt-''${(%):-%n}.zsh" ]]; then
          source "$XDG_CACHE_HOME/p10k-instant-prompt-''${(%):-%n}.zsh"
        fi

        emulate zsh -c "$(direnv hook zsh)"
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
          "alias-finder" "dirhistory"
          "git" "history" "python"
          "rsync" "ruby" "safe-paste"
          "sudo" "systemd" "zbell"
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
          src = ./powerlevel10k;
          file = "p10k.zsh";
        }
        {
          name = "powerlevel10k-config";
          src = ./powerlevel10k;
          file = "p10k-portable.zsh";
        }
      ];

    };

    xdg.configFile = {
      # Configure lsd, the next-gen ls command.
      "lsd/config.yaml".source = ./lsd-config.yaml;
    };
  };
}
