{ pkgs, lib, config, ... }: {

  options.myHome.neovim.nvim-cmp.enable = lib.mkEnableOption "nvim-cmp";

  config = lib.mkIf config.myHome.neovim.nvim-cmp.enable {

    programs.neovim.plugins = with pkgs.vimPlugins; [
      {
        plugin = nvim-cmp;
        config = ''
          lua << END

            -- Set up nvim-cmp.
            local cmp = require('cmp')

            cmp.setup({

              snippet = {
                -- Use UltiSnips as our snippet engine.
                expand = function(args)
                  vim.fn["UltiSnips#Anon"](args.body)
                end,
              },

              window = {
                -- completion = cmp.config.window.bordered(),
                -- documentation = cmp.config.window.bordered(),
              },

              -- Command mappings.
              mapping = cmp.mapping.preset.insert({
                ["<C-j>"] = cmp.mapping.select_next_item(),
                ["<C-k>"] = cmp.mapping.select_prev_item(),
                ['<C-b>'] = cmp.mapping.scroll_docs(-4),
                ['<C-f>'] = cmp.mapping.scroll_docs(4),
                ['<C-Space>'] = cmp.mapping.complete(),
                ['<C-e>'] = cmp.mapping.abort(),
                ['<CR>'] = cmp.mapping.confirm({ select = true }),
              }),

              sources = cmp.config.sources({
                { name = 'nvim_lsp' },
                { name = 'ultisnips' },
              }, {
                { name = 'buffer' },
              })
            })

            -- Set configuration for git commits.
            cmp.setup.filetype('gitcommit', {
              sources = cmp.config.sources({
                { name = 'git' },
              }, {
                { name = 'buffer' },
              })
            })
            require("cmp_git").setup()

            -- Set configuratin for LaTeX files.
            cmp.setup.filetype("tex", {
              sources = {
                { name = 'vimtex' },
                { name = 'buffer' },
              },
            })

            -- Use buffer source for `/` and `?`.
            cmp.setup.cmdline({ '/', '?' }, {
              mapping = cmp.mapping.preset.cmdline(),
              sources = {
                { name = 'buffer' }
              }
            })

            -- Use cmdline & path source for ':'.
            cmp.setup.cmdline(':', {
              mapping = cmp.mapping.preset.cmdline(),
              sources = cmp.config.sources({
                { name = 'path' }
              }, {
                { name = 'cmdline' }
              }),
              matching = { disallow_symbol_nonprefix_matching = false }
            })

          END
        '';
      }

      cmp-buffer
      cmp-cmdline
      cmp-git
      cmp-nvim-lsp
      cmp-nvim-ultisnips
      cmp-path
      cmp-vimtex
      ultisnips

    ];
  };
}
