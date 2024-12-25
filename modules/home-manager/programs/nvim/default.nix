{ pkgs, lib, config, ... }: {

  imports = [ ./ale.nix ./coc.nix ./nvim-cmp.nix ./ultisnips.nix ./ycm.nix ];

  options.myHome.neovim.enable = lib.mkEnableOption "neovim";

  config = lib.mkIf config.myHome.neovim.enable {

    # Ensure the undodir gets created.
    home.file.".cache/nvim/undodir/README".text = "Created by Home Manager.";

    # Manage theming ourselves.
    stylix.targets.neovim.enable = false;

    # Install ALE by default.
    myHome.neovim.ale.enable = lib.mkDefault true;

    # Use nvim-cmp as our completion engine by default.
    myHome.neovim.nvim-cmp.enable = lib.mkDefault true;

    # Install UltiSnips by default.
    myHome.neovim.ultisnips.enable = lib.mkDefault true;

    # Load in our personal snippets.
    xdg.configFile."nvim/UltiSnips".source = ./UltiSnips;

    # Install and configure neovim.
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

        " Clear highlights.
        nnoremap <Esc> :noh<cr>

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

        " Open a new empty buffer.
        nnoremap <leader>b :enew<cr>

        " Enter insert mode when opening a terminal window.
        autocmd TermOpen * :startinsert
        autocmd BufEnter * if &buftype == 'terminal' | :startinsert | endif

      '';

      extraPackages = with pkgs; [

        # Install plugin dependencies.
        black fd nixfmt-rfc-style
        ripgrep shfmt tree-sitter

      ];

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

            " Make sure the <leader> key is correctly set.
            let mapleader = "${leader}"

            lua << END

              -- Keep the window layout when deleting buffers.
              require('mini.bufremove').setup()
              vim.keymap.set("n", "<leader>x", "<cmd> lua MiniBufremove.delete()<CR>")

              -- Toggle comments with `gc`.
              require('mini.comment').setup()

              -- Automatically match pairs.
              require('mini.pairs').setup()

              -- Add surroundings with `sa`.
              -- More helpful commands available.
              require('mini.surround').setup()

            END
          '';
        }
        {
          plugin = nvim-lspconfig;
          config = ''

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
          plugin = nvim-treesitter-parsers.latex;
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
            nnoremap <leader>ff <cmd>Telescope find_files<CR>
            nnoremap <leader>fg <cmd>Telescope live_grep<CR>
            nnoremap <leader>fb <cmd>Telescope buffers<CR>
            nnoremap <leader>fh <cmd>Telescope help_tags<CR>

          '';
        }
        {
          plugin = vim-snippets;
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
