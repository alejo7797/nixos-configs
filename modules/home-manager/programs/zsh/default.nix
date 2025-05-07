{ config, pkgs, ... }: {

  programs.zsh = {

    autocd = true;

    dotDir = ".config/zsh";

    history.path = "${config.xdg.stateHome}/zsh/history";

    initExtra = ''
      # Accept suggestion with Shift+Tab.
      bindkey '^[[Z' autosuggest-accept

      # Sets window title in Kitty as desired.
      ZSH_THEME_TERM_TAB_TITLE_IDLE="%n@%m:%~"

      # OhMyZsh...
      unalias gap
    '';

    my.powerlevel10k.enable = true;

    oh-my-zsh.enable = true;

    plugins =

      [
        {
          name = "nix-shell"; # Use Zsh under nix-shell.
          src = "${pkgs.zsh-nix-shell}/share/zsh-nix-shell";
        }
      ];

  };

  # Need /etc/zshenv to set ZDOTDIR.
  home.file.".zshenv".enable = false;
}
