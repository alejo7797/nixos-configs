{ pkgs, lib, config, ... }:

let
  cfg = config.myHome.neovim;
in

{
  imports = [ ./ale.nix ];

  options.myHome.neovim.enable = lib.mkEnableOption "neovim";

  config = lib.mkIf cfg.enable {
     # Load in our personal snippets.
    xdg.configFile."nvim/snippets".source = ./snippets;

    # Install and configure neovim using nvf.
    programs.nvf = {
      enable = true;

      settings = {
        vim = {
          # Install plugin dependencies.
          extraPackages = with pkgs; [
            fd fzf ripgrep
          ];

          # Don't leave search highlights lying around.
          hideSearchHighlight = true;

          # Don't show line numbers by default.
          lineNumberMode = "none";

          # Use the system clipboard.
          useSystemClipboard = true;

          # Enable persistent undo.
          undoFile.enable = true;

          # Enable nvim-autopairs.
          autopairs.nvim-autopairs.enable = true;

          # Enable nvim-cmp.
          autocomplete.nvim-cmp = {
            enable = true;

            # Completion sources.
            sourcePlugins = with pkgs.vimPlugins; [
              cmp-buffer
              cmp-nvim-lsp
              cmp_luasnip
              cmp-path
              cmp-cmdline
              cmp-git
              cmp-vimtex
            ];
          };

          # Help find keybindings.
          binds = {
            cheatsheet.enable = true;
            whichKey.enable = true;
          };
          
          # Enable comment-nvim.
          comments.comment-nvim.enable = true;

          # Enable and configure nvim-tree-lua.
          filetree.nvimTree = {
            enable = true;
            setupOpts = {
              git.enable = true;
            };
          };

          # Enable git integration.
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
            
          # Enable bufferline.
          tabline.nvimBufferline.enable = true;

          # Enable telescope.
          telescope.enable = true;

          # Enable and configure toggleterm.
          terminal.toggleterm = {
            enable = true;
            lazygit.enable = true;
            setupOpts.direction = "vertical";
          };

          # Configure nvim-treesitter.
          treesitter = {
            context.enable = true;

            # Extra treesitter grammars to install.
            grammars =
              with pkgs.vimPlugins.nvim-treesitter-parsers;
              [
                gitcommit hyprlang latex nginx
              ];
          };

          ui = {
            # Enable borders.
            borders.enable = true;

            # Enable nvim-colorizer.
            colorizer.enable = true;
            
            # Enable fastaction.nvim.
            fastaction.enable = true;

            # Enable noice.nvim.
            noice.enable = true;
          };

          # Enable nvim-surround.
          utility.surround.enable = true;

          visuals = {
            # Smooth scrolling.
            cinnamon-nvim.enable = true;

            # Highlight changes when using undo.
            highlight-undo.enable = true;

            # Enable indentation guides.
            indent-blankline.enable = true;

            # Enable nvim-cursorline.
            nvim-cursorline.enable = true;

            # Enable devicons.
            nvim-web-devicons.enable = true;
          };

          lsp = {
            # Do not autoformat files.
            formatOnSave = false;

            # Enable nvim-lightbulb.
            lightbulb.enable = true;

            # Enable lsp_signature.
            lspSignature.enable = true;

            # Enable trouble.
            trouble.enable = true;
          };

          # Language configuration.
          languages = {
            enableExtraDiagnostics = true;
            enableFormat = true;
            enableLSP = true;
            enableTreesitter = true;

            bash.enable = true;
            clang.enable = true;
            css.enable = true;
            html.enable = true;
            markdown.enable = true;
            nix.enable = true;
            python.enable = true;
          };

          # Extra plugin configuration.
          extraPlugins = with pkgs.vimPlugins; {
            base16-nvim = {
              package = base16-nvim;
              setup = ''
                vim.cmd("colorscheme base16-tomorrow-night")
              '';
            };
            vimtex = {
              package = vimtex;
              setup = ''
                vim.g.vimtex_view_method = "zathura_simple"
              '';
            };
          };
        };
      };
    };
  };
}
