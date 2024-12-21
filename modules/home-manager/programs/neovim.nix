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

        " Copy to the clipboard.
        nmap <C-c> "+yy
        vmap <C-c> "+y

        " Paste from the clipboard.
        nmap <C-v> "+p

        " Configure the behaviour of tabs and spaces.
        set expandtab
        set tabstop=8
        set shiftwidth=4
        set softtabstop=-1

        " In C.
        autocmd FileType c setlocal shiftwidth=2

        " In Nix.
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

        " Move between, and close, open buffers.
        nnoremap <leader>n :bnext<cr>
        nnoremap <leader>p :bprevious<cr>
        nnoremap <leader>d :bdelete<cr>

        " Enter insert mode when opening a terminal window.
        autocmd TermOpen * :startinsert

        " Close the terminal buffer when the process exits.
        autocmd TermClose * if !v:event.status | exe 'bdelete! '..expand('<abuf>') | endif

        " Fix an nnoying issue with underlined syntax highlighting.
        hi clear Underlined
        hi Underlined term=underline cterm=underline gui=underline

      '';

      extraPackages = with pkgs; [

        # Install desired linters & fixers.
        black llvmPackages_19.clang-tools
        nixfmt-rfc-style shfmt

      ];

      plugins = with pkgs.vimPlugins; [

        {
          plugin = ale;
          config = ''

            " Set desired linters per filetype.
            let g:ale_linters = {
            \   'python': ['flake8'],
            \   'c': ['clangd'],
            \   'tex': ['chktex'],
            \}

            " Enable desired fixers per filetype.
            let g:ale_fixers = {
            \   '*': ['remove_trailing_lines', 'trim_whitespace'],
            \   'html': ['prettier'],
            \   'css': ['prettier'],
            \   'scss': ['prettier'],
            \   'javascript': ['standard'],
            \   'sh': ['shfmt'],
            \   'python': ['black'],
            \   'c': ['clang-format', 'clangtidy'],
            \   'tex': ['latexindent'],
            \   'bib': ['bibclean'],
            \   'nix': ['nixfmt'],
            \}

            " ALEFix files on save.
            let g:ale_fix_on_save = 1

            " Except for the following filetypes.
            let g:ale_fix_on_save_ignore = {
            \   'nix': ['nixfmt'],
            \}

            " Options to pass to shfmt.
            let g:ale_sh_shfmt_options = '-i 4'

            " Options to pass to latexindent.
            let g:ale_tex_latexindent_options = '-y="defaultIndent:'''    '''" -c /tmp'

          '';
        }

        {
          plugin = base16-nvim;
          config = ''
            set background=dark
            colorscheme base16-tomorrow-night
          '';
        }

        {
          plugin = deoplete-nvim;
          config = ''

            " Enable deoplete.
            let g:deoplete#enable_at_startup=1

            " Use ALE as a completion source.
            call deoplete#custom#option('sources', {
            \ '_': ['ale', 'omni'],
            \})

            " Integrate vimtex with deoplete.
            call deoplete#custom#var('omni', 'input_patterns', {
            \ 'tex': g:vimtex#re#deoplete
            \})

            " Enable <TAB> completion.
            inoremap <expr><TAB> pumvisible() ? "\<C-n>" : "\<TAB>"
            inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<S-TAB>"

          '';
        }

        {
          plugin = nerdtree;
          config = ''

            " Binds to open NERDTree and to focus on the open file.
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
          plugin = vim-airline;
          config = ''
            # Enable the tabline.
            let g:airline#extensions#tabline#enabled=1

            # Set the symbol font appropriately.
            if &t_Co > 255
              let g:airline_powerline_fonts=1
            else
              let g:airline_symbols_ascii=1
            endif
          '';
        }

        {
          plugin = vim-airline-themes;
          config = ''
            let g:airline_theme='base16_tomorrow_night'
          '';
        }

        {
          plugin = vim-devicons;
          config = ''
            # Disable devicons in tty context.
            if &t_Co = 8
              let g:webdevicons_enable=0
            endif
          '';
        }

        {
          plugin = vimtex;
          config = ''
              let g:vimtex_view_method='zathura_simple'
            '';
        }

        delimitMate
        nerdcommenter
        nerdtree-git-plugin
        vim-better-whitespace
        vim-fugitive
        vim-surround
        vim-gitgutter
        vim-oscyank
        vim-wayland-clipboard

      ];

    };
  };
}
