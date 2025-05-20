{
  programs.zsh.oh-my-zsh = {

    plugins = [
      "alias-finder"
      "dirhistory"
      "git"
      "history"
      "python"
      "safe-paste"
      "sudo"
      "systemd"
      "zbell"
    ];

    extraConfig = ''
      ENABLE_CORRECTION="true"
      HIST_STAMPS="yyyy-mm-dd"

      zstyle ':omz:plugins:alias-finder' autoload yes
      zstyle ':omz:plugins:alias-finder' exact yes
      zstyle ':omz:plugins:alias-finder' cheaper yes

      zbell_ignore=(
        bash
        nix-shell
        git
        glola
        ipython
        journalctl
        less
        man
        sage
        sc-status
        scu-status
        ssh
        vim
        zsh
      )
    '';

  };
}
