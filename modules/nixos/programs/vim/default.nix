{ pkgs, ... }: {

  programs.vim = {

    defaultEditor = true;

    package = pkgs.vim.customize {

      vimrcConfig = {

        packages.my.start = with pkgs.vimPlugins; [

          base16-vim # Cute colorscheme collection.
          vim-airline # Lean & mean Vim status bar.
          vim-airline-themes # And its themes repo.
          vim-oscyank # Universal clipboard plugin.

        ];

        customRC = builtins.readFile ./vimrc;

      };

    };

  };
}
