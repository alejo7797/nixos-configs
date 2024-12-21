{ pkgs, lib, config, ... }: {

  options.myHome.neovim.enable = lib.mkEnableOption "neovim configuration";

  config = lib.mkIf config.myHome.neovim.enable {

    # Ensure the undodir gets created.
    home.file.".cache/nvim/undodir/README".text = "Created by Home Manager.";

    # Specify the plugin for Stylix to use.
    stylix.targets.neovim.plugin = "base16-nvim";

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

        " Show whitespace with `set list`.
        set lcs+=space:·

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

        " Move between and close open buffers.
        nnoremap <leader>n :bnext<cr>
        nnoremap <leader>p :bprevious<cr>
        nnoremap <leader>d :bdelete<cr>

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

      # Enable Coc.
      coc = {
        enable = true;

        pluginConfig = "";
        settings = {};

      };

      plugins = with pkgs.vimPlugins; [

        {
          plugin = gitsigns-nvim;
          config = ''
            lua << END
              require('gitsigns').setup()
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
              require'nvim-web-devicons'.setup {

              }
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
