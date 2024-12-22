{ pkgs, lib, config, ... }: {

  options.myHome.neovim.enable = lib.mkEnableOption "neovim configuration";

  config = lib.mkIf config.myHome.neovim.enable {

    # Ensure the undodir gets created.
    home.file.".cache/nvim/undodir/README".text = "Created by Home Manager.";

    # Manage theming ourselves.
    stylix.targets.neovim.enable = false;

    # Configure neovim.
    programs.neovim = let

      # Set the <leader> key.
      leader = ",";

    in {

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

        " Set a lower update time.
        set updatetime=100

        " Always show the sign column.
        set signcolumn=yes

        " Show whitespace with `set list`.
        set lcs+=space:·

        " Color support in the linux console.
        set termguicolors

        " Set the <leader> key.
        let mapleader = "${leader}"
        let maplocalleader = "${leader}"

        " Use the system clipboard.
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

        " Leave folds open by default.
        set foldmethod=syntax
        set foldlevelstart=99

        " Enable persistent undo.
        set undofile
        set undodir=${config.home.homeDirectory}/.cache/nvim/undodir

        " Open and close buffers.
        nnoremap <leader>b :enew<cr>
        nnoremap <leader>x :bdelete<cr>

        " Enter insert mode when opening a terminal window.
        autocmd TermOpen * :startinsert
        autocmd BufEnter * if &buftype == 'terminal' | :startinsert | endif

      '';

      extraPackages = with pkgs; [

        black fd llvmPackages_19.clang-tools
        nixfmt-rfc-style shfmt tree-sitter

      ];

      # Enable Coc.
      coc = {
        enable = true;

        pluginConfig = ''

          " Use tab for trigger completion with characters ahead and navigate.
          inoremap <silent><expr> <TAB>
              \ coc#pum#visible() ? coc#pum#next(1) :
              \ CheckBackspace() ? "\<Tab>" :
              \ coc#refresh()
          inoremap <expr><S-TAB> coc#pum#visible() ? coc#pum#prev(1) : "\<C-h>"

          " Make <CR> to accept selected completion item or notify coc.nvim to format.
          inoremap <silent><expr> <CR> 
              \ coc#pum#visible() ? coc#pum#confirm()
              \: "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"

          function! CheckBackspace() abort
            let col = col('.') - 1
            return !col || getline('.')[col - 1]  =~# '\s'
          endfunction

          " Use <C-space> to trigger completion.
          inoremap <silent><expr> <C-space> coc#refresh()

          " Use `[g` and `]g` to navigate diagnostics.
          nmap <silent> [g <Plug>(coc-diagnostic-prev)
          nmap <silent> ]g <Plug>(coc-diagnostic-next)

          " GoTo code navigation.
          nmap <silent> gd <Plug>(coc-definition)
          nmap <silent> gy <Plug>(coc-type-definition)
          nmap <silent> gi <Plug>(coc-implementation)
          nmap <silent> gr <Plug>(coc-references)

          " Highlight the symbol and its references when holding the cursor.
          autocmd CursorHold * silent call CocActionAsync('highlight')

          " Symbol renaming.
          nmap <leader>rn <Plug>(coc-rename)

          " Formatting selected code.
          xmap <leader>f  <Plug>(coc-format-selected)
          nmap <leader>f  <Plug>(coc-format-selected)

          " Remap keys for applying code actions at the cursor position.
          nmap <leader>ac  <Plug>(coc-codeaction-cursor)
          " Remap keys for apply code actions affect whole buffer
          nmap <leader>as  <Plug>(coc-codeaction-source)
          " Apply the most preferred quickfix action to fix diagnostic on the current line
          nmap <leader>qf  <Plug>(coc-fix-current)

          " Add `:Format` command to format current buffer.
          command! -nargs=0 Format :call CocActionAsync('format')

          " Add `:Fold` command to fold current buffer.
          command! -nargs=? Fold :call CocAction('fold', <f-args>)

        '';
        settings = {};

      };

      plugins = with pkgs.vimPlugins; [

        {
          plugin = base16-nvim;
          config = ''
              colorscheme base16-tomorrow-night
          '';
        }

        {
          plugin = gitsigns-nvim;
          config = ''
            lua << END
              require('gitsigns').setup()
            END
          '';
        }

        {
          plugin = lualine-nvim;
          config = ''
            lua << END
              require('lualine').setup {

                options = {

                  -- Follow base16-nvim.
                  theme = 'base16',

                  -- Always show the tabline.
                  always_show_tabline = true,

                },

                -- Set up the tabline.
                tabline = {
                  lualine_a = {'buffers'},
                  lualine_b = {'branch'},
                  lualine_c = {'filename'},
                  lualine_x = {},
                  lualine_y = {},
                  lualine_z = {'tabs'}
                },

              }
            END
          '';
        }

        {
          plugin = mini-nvim;
          config = ''
            lua << END

              require('mini.bufremove').setup()
              require('mini.comment').setup()
              require('mini.pairs').setup()
              require('mini.surround').setup()

            END
          '';
        }

        {
          plugin = nvim-tree-lua;
          config = ''
            lua << END

              -- Disable netrw.
              vim.g.loaded_netrw = 1
              vim.g.loaded_netrwPlugin = 1

              -- Load nvimtree.
              require('nvim-tree').setup()

              -- Open and close nvimtree.
              vim.keymap.set("n", "<C-n>", "<cmd>NvimTreeToggle<CR>")

            END

          '';
        }

        {
          plugin = nvim-treesitter;
          config = ''

          '';
        }

        {
          plugin = nvim-web-devicons;
          config = ''
            lua << END

              -- Do not enable devicons in the linux console.
              if os.getenv("TERM") ~= linux then
                require('nvim-web-devicons').setup()
              end
            
            END
          '';
        }

        {
          plugin = telescope-nvim;
          config = ''

            " Make sure the <leader> key is correctly set.
            let mapleader = "${leader}"

            " Find files using Telescope command-line sugar.
            nnoremap <leader>ff <cmd>Telescope find_files<cr>
            nnoremap <leader>fg <cmd>Telescope live_grep<cr>
            nnoremap <leader>fb <cmd>Telescope buffers<cr>
            nnoremap <leader>fh <cmd>Telescope help_tags<cr>

          '';
        }

        {
          plugin = trouble-nvim;
          config = ''

          '';
        }

        {
          plugin = vimtex;
          config = ''

            " Use Zathura as the VimTeX PDF viewer.
            let g:vimtex_view_method='zathura_simple'

          '';
        }

      ];

    };
  };
}
