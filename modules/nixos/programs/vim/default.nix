{ pkgs, ... }: {

  programs.vim = {

    # Set $EDITOR to vim.
    defaultEditor = true;

    # Include some useful plugins.
    package = pkgs.vim.customize {

      vimrcConfig = {

        packages.my.start = with pkgs.vimPlugins; [

          base16-vim # Colorscheme collection.
          vim-airline # Lightweight status bar.
          vim-airline-themes # And its themes.
          vim-oscyank # Clipboard solution.

        ];

        # Basic vimrc file we can use anywhere.
        customRC = builtins.readFile ./vimrc;

      };

    };

  };
}
