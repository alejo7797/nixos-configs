{
  pkgs,
  config,
  lib,
  ...
}:

let
  cfg = config.myHome.neovim;
in

{
  imports = [ ./latex.nix ];

  options.myHome.neovim.enable = lib.mkEnableOption "NeoVim";

  config = lib.mkIf cfg.enable {

    # Load in our personal snippets.
    xdg.configFile."nvf/snippets".source = ./snippets;

    # Enable LaTeX support.
    myHome.neovim.latex.enable = true;

    # Configure NeoVim using nvf.
    programs.nvf = {
      enable = true;
      settings.vim = {

        hideSearchHighlight = true;
        lineNumberMode = "none";
        useSystemClipboard = true;
        undoFile.enable = true;

        options = {
          # Visually indent wrapped lines.
          breakindent = true;

          # Set the window title.
          title = true;

          # A faster update time.
          updatetime = 100;

          # Traverse line breaks.
          whichwrap = "b,s,<,>,[,]";
        };

        luaConfigRC.terminal = ''
          vim.cmd([[
            " Enter insert mode when focusing on the terminal.
            autocmd TermOpen * :startinsert
            autocmd BufEnter * if &buftype == 'terminal' | :startinsert | endif
          ]])
        '';

        keymaps = [
          {
            key = "<leader>t";
            mode = "n";
            action = "<cmd>Neotree toggle reveal<CR>";
            desc = "Toggle the neo-tree window.";
          }
          {
            key = "<C-t>";
            mode = "n";
            action = "<cmd>rightb vertical terminal<CR>";
            desc = "Open a terminal window.";
          }
        ];

        autopairs = {
          nvim-autopairs.enable = true;
        };

        autocomplete = {
          nvim-cmp = {
            enable = true;
            sourcePlugins =
              with pkgs.vimPlugins;
              [
                cmp-buffer
                cmp-cmdline
                cmp-git
                cmp-nvim-lsp
                cmp-path
              ];
          };
        };

        binds = {
          cheatsheet.enable = true;
          whichKey.enable = true;
        };

        comments = {
          comment-nvim.enable = true;
        };

        filetree = {
          neo-tree.enable = true;
        };

        git = {
          gitsigns.enable = true;
          vim-fugitive.enable = true;
        };

        lsp = {
          formatOnSave = true;
          lightbulb.enable = true;
          lspSignature.enable = true;
          trouble.enable = true;
        };

        notes = {
          todo-comments.enable = true;
        };

        notify = {
          nvim-notify.enable = true;
        };

        snippets = {
          luasnip = {
            enable = true;
            providers = [
              "friendly-snippets"
            ];
          };
        };

        statusline = {
          lualine = {
            enable = true;
            refresh.statusline = 100;
            setupOpts = {
              options.theme = "base16";
            };
          };
        };

        tabline = {
          nvimBufferline.enable = true;
        };

        telescope.enable = true;
        extraPackages = with pkgs; [ fd ripgrep ];

        treesitter = {
          enable = true;

          context = {
            enable = true;
            setupOpts.max_lines = 6;
          };

          grammars =
            with pkgs.vimPlugins;
            with nvim-treesitter.builtGrammars;
            [
              dockerfile
              gitcommit
              hyprlang
              javascript
              json
              make
              nginx
              php
              ruby
              scss
              yaml
            ];
        };

        ui = {
          borders.enable = true;
          colorizer.enable = true;
          fastaction.enable = true;

          noice = {
            enable = true;
            setupOpts = {
              lsp.signature.enabled = true;
            };
          };
        };

        utility = {
          surround.enable = true;
        };

        visuals = {
          highlight-undo.enable = true;
          nvim-web-devicons.enable = true;

          indent-blankline = {
            enable = true;
            setupOpts = {
              scope.exclude.language = [ "nix" ];
            };
          };
        };

        languages = {
          enableExtraDiagnostics = true;
          enableFormat = true;
          enableLSP = true;
          enableTreesitter = true;

          clang = {
            enable = true;
            dap.enable = true;
          };

          nix = {
            enable = true;
            format.type = "nixfmt";
          };

          python = {
            enable = true;
            dap.enable = true;
            format.type = "black";
          };

          bash.enable = true;
          css.enable = true;
          html.enable = true;
          markdown.enable = true;
        };

        extraPlugins = with pkgs.vimPlugins; {
          vim-better-whitespace = {
            package = vim-better-whitespace;
          };
        };
      };
    };
  };
}
