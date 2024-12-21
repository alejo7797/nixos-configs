{ pkgs, lib, config, ... }: {

  options.myHome.neovim.enable = lib.mkEnableOption "neovim configuration";

  config = lib.mkIf config.myHome.neovim.enable {

    # Ensure the undodir gets created.
    home.file.".cache/nvim/undodir/README".text = "Created by Home Manager.";

    # Configure neovim.
    programs.neovim = {
      enable = true;

      # Symlink vim and vimdiff.
      vimAlias = true;
      vimdiffAlias = true;

      extraConfig = ''

        " Automatically write out, e.g. when changing buffers.
        set autowriteall

        " Automatically set the working directory.
        set autochdir

        " Set the terminal window title.
        set title

        " Show whitespace with `set list`.
        set lcs+=space:·

        " Copy to and paste from the system clipboard.
        vnoremap <C-c> "+y
        nnoremap <C-v> "+p

        " Configure the behaviour of tabs.
        set expandtab
        set shiftwidth=4

        " In C.
        autocmd FileType c setlocal shiftwidth=2

        " In nix.
        autocmd FileType nix setlocal shiftwidth=2

        " Traverse line breaks with the arrow keys.
        set whichwrap=b,s,<,>,[,]

        " Visually indent wrapped lines.
        set breakindent

        " Manage code folding.
        set foldmethod=syntax
        set foldlevelstart=99

        " Enable persistent undo.
        set undofile
        set undodir=${config.home.homeDirectory}/.cache/nvim/undodir

        " Move between buffers.
        nnoremap <leader>n :bnext<cr>
        nnoremap <leader>p :bprevious<cr>

        " Enter insert mode when opening a terminal window.
        autocmd TermOpen * :startinsert

        " Close the terminal buffer when the process exits.
        autocmd TermClose * if !v:event.status | exe 'bdelete! '..expand('<abuf>') | endif

      '';

      extraPackages = with pkgs; [

        # Install desired linters & fixers.
        black llvmPackages_19.clang-tools
        nixfmt-rfc-style shfmt

      ];

      plugins = with pkgs.vimPlugins; [

        {
          plugin = nerdtree;
          config = ''

            " Open and close NERDTree.
            nnoremap <C-n> :NERDTreeToggle<CR>
            nnoremap <C-f> :NERDTreeFind<CR>

            " Start NERDTree when Vim is started without file arguments.
            autocmd StdinReadPre * let s:std_in=1
            autocmd VimEnter * if argc() == 0 && !exists('s:std_in') | NERDTree | endif

            " Start NERDTree when Vim starts with a directory argument.
            autocmd StdinReadPre * let s:std_in=1
            autocmd VimEnter * if argc() == 1 && isdirectory(argv()[0]) && !exists('s:std_in') |
            \   execute 'NERDTree' argv()[0] | wincmd p | enew | execute 'cd '.argv()[0] | endif

            " Exit Vim if NERDTree is the only window remaining in the only tab.
            autocmd BufEnter *
            \   if tabpagenr('$') == 1 && winnr('$') == 1 && exists('b:NERDTree') && b:NERDTree.isTabTree() |
            \       call feedkeys(":quit\<CR>:\<BS>") |
            \   endif

            " Close the tab if NERDTree is the only window remaining in it.
            autocmd BufEnter *
            \   if winnr('$') == 1 && exists('b:NERDTree') && b:NERDTree.isTabTree() |
            \       call feedkeys(":quit\<CR>:\<BS>") |
            \   endif

          '';
        }

        {
          plugin = telescope-nvim;
          config = ''

            " Find files using Telescope command-line sugar.
            nnoremap <leader>ff <cmd>Telescope find_files<cr>
            nnoremap <leader>fg <cmd>Telescope live_grep<cr>
            nnoremap <leader>fb <cmd>Telescope buffers<cr>
            nnoremap <leader>fh <cmd>Telescope help_tags<cr>

          '';
        }

        {
          plugin = lualine-nvim;
          config = ''

          '';
        }

        {
          plugin = nvim-web-devicons;
          config = ''


          '';
        }

        {
          plugin = vimtex;
          config = ''

            " Use zathura to view compiled PDFs.
            let g:vimtex_view_method='zathura_simple'

          '';
        }

        comment-nvim
        gitsigns-nvim
        nerdtree-git-plugin
        nvim-surround

      ];

    };
  };
}
