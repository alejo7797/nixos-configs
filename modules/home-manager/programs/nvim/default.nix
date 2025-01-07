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

    # Install and configure neovim using nvf.
    programs.nvf = {
      enable = true;

      settings = {
        vim = {
          # Install plugin dependencies.
          extraPackages = with pkgs; [ ripgrep ];

          # Don't leave search highlights lying around.
          hideSearchHighlight = true;

          # Don't show line numbers.
          lineNumberMode = "none";

          # Use the system clipboard.
          useSystemClipboard = true;

          # Enable persistent undo.
          undoFile.enable = true;

          # Extra options to set.
          options = {
            # Set the terminal window title.
            title = true;

            # Set a faster update time.
            updatetime = 100;

            # Traverse line breaks.
            whichwrap = "b,s,<,>,[,]";

            # Disable line wrapping.
            wrap = false;
          };

          # Handy terminal autocommands.
          luaConfigRC.terminal = ''
            vim.cmd([[
              " Enter insert mode when focusing on the terminal.
              autocmd TermOpen * :startinsert
              autocmd BufEnter * if &buftype == 'terminal' | :startinsert | endif
            ]])
          '';

          # Custom keybindings.
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

          # Enable nvim-autopairs.
          autopairs.nvim-autopairs.enable = true;

          # Enable nvim-cmp.
          autocomplete.nvim-cmp = {
            enable = true;

            # Completion sources.
            sourcePlugins = with pkgs.vimPlugins; [
              cmp-buffer
              cmp-cmdline
              cmp-git
              cmp-nvim-lsp
              cmp-path
            ];
          };

          # Help find keybindings.
          binds = {
            cheatsheet.enable = true;
            whichKey.enable = true;
          };

          # Enable comment-nvim.
          comments.comment-nvim.enable = true;

          # Enable neo-tree.nvim.
          filetree.neo-tree.enable = true;

          # Enable Git integration.
          git.enable = true;

          # Highlight to-do comments.
          notes.todo-comments.enable = true;

          # Enable notifications.
          notify.nvim-notify.enable = true;

          # Enable luasnip.
          snippets.luasnip = {
            enable = true;
            providers = [
              "friendly-snippets"
            ];
          };

          # Enable and configure lualine.
          statusline.lualine = {
            enable = true;
            refresh.statusline = 100;
            setupOpts = {
              options.theme = "base16";
            };
          };

          # Enable bufferline.nvim.
          tabline.nvimBufferline.enable = true;

          # Enable telescope.nvim.
          telescope.enable = true;

          # Configure nvim-treesitter.
          treesitter = {
            # Code context support.
            context = {
              enable = true;
              # Limit the amount of space to take up.
              setupOpts.max_lines = 6;
            };
            # Install additional treesitter grammars.
            grammars = with pkgs.vimPlugins.nvim-treesitter.builtGrammars; [
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
            # Enable borders.
            borders.enable = true;

            # Enable nvim-colorizer.
            colorizer.enable = true;

            # Enable fastaction.nvim.
            fastaction.enable = true;

            # Enable and configure noice.nvim.
            noice = {
              enable = true;
              setupOpts = {
                # Enable signature help.
                lsp.signature.enabled = true;
              };
            };
          };

          # Enable nvim-surround.
          utility.surround.enable = true;

          visuals = {
            # Enable highlight-undo.nvim.
            highlight-undo.enable = true;

            # Enable and configure indent-blankline.nvim.
            indent-blankline = {
              enable = true;
              setupOpts = {
                # Disable scope highlighting in Nix.
                scope.exclude.language = [ "nix" ];
              };
            };

            # Enable nvim-web-devicons.
            nvim-web-devicons.enable = true;
          };

          lsp = {
            # Format files automatically.
            formatOnSave = true;

            # Enable nvim-lightbulb.
            lightbulb.enable = true;

            # Enable lsp_signature.
            lspSignature.enable = true;

            # Enable trouble.
            trouble.enable = true;
          };

          # Language configuration.
          languages = {
            # Features to enable by default.
            enableExtraDiagnostics = true;
            enableFormat = true;
            enableLSP = true;
            enableTreesitter = true;

            # C/C++.
            clang = {
              enable = true;
              # Debugging support.
              dap.enable = true;
            };

            # Nix.
            nix = {
              enable = true;
              # Use the official Nix formatter.
              format.type = "nixfmt";
            };

            # Python.
            python = {
              enable = true;
              # Debugging support.
              dap.enable = true;
              # Use the Black formatter.
              format.type = "black";
            };

            # Other languages to support.
            bash.enable = true;
            css.enable = true;
            html.enable = true;
            markdown.enable = true;
          };

          # Install additional plugins.
          extraPlugins = with pkgs.vimPlugins; {
            # Good base16 support.
            base16-nvim = {
              package = base16-nvim;
              setup = ''
                vim.cmd.colorscheme('base16-tomorrow-night');
              '';
            };

            # Highlight trailing whitespace.
            vim-better-whitespace = {
              package = vim-better-whitespace;
            };
          };
        };
      };
    };
  };
}
