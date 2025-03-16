{ pkgs, ... }: {

  programs.vim = {

    defaultEditor = true;

    package = pkgs.vim.customize {
      vimrcConfig.customRC = ''

        if !has('nvim')
          " Do not create a .viminfo file in users' $HOME.
          set viminfofile=$HOME/.local/state/vim/viminfo
        endif

      '';
    };

  };
}
