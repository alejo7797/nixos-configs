{ config, lib, pkgs, ... }:

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

        # Standard ls aliases.
        l = "ls -lah";
        lt = "ls --tree";
        la = "ls -a";

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

      initExtra = ''
        # Accept suggestion with Shift+Tab.
        bindkey '^[[Z' autosuggest-accept

        # Show directories first in list.
        lsd_params="--group-dirs first"

        if (( terminfo[colors] == 8 )); then
          # Don't show icons in TTY.
          lsd_params="$lsd_params --icon never"
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
            bash dmesg nix-shell
            git htop journalctl
            less man sc-status
            scu-status ssh vim
          )
        '';
      };

      plugins = [
        {
          name = "nix-shell"; # Use Zsh under nix-shell.
          src = "${pkgs.zsh-nix-shell}/share/zsh-nix-shell";
        }
      ];

    };

    home = {

      packages = with pkgs; [ lsd ];

      file.".zshenv".enable = false;

    };
  };
}
