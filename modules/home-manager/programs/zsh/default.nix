{ config, pkgs, ... }: {

  programs.zsh = {

    autocd = true;

    dotDir = ".config/zsh";

    history.path = "${config.xdg.stateHome}/zsh/history";

    initContent = ''
      # Accept suggestion with Shift+Tab.
      bindkey '^[[Z' autosuggest-accept

      # OhMyZsh...
      unalias gap
    '';

    my.powerlevel10k.enable = true;

    oh-my-zsh.enable = true;

    plugins = [

      {
        name = "nix-shell"; # Use Zsh under nix-shell.
        src = "${pkgs.zsh-nix-shell}/share/zsh-nix-shell";
      }

    ];

  };

  # Need /etc/zshenv to set ZDOTDIR.
  home.file.".zshenv".enable = false;
}
