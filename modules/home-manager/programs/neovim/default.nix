{
  lib,
  config,
  pkgs,
  ...
}:

let
  cfg = config.myHome.neovim;
in

{
  options.myHome.neovim.enable = lib.mkEnableOption "Neovim config";

  config = lib.mkIf cfg.enable {

    programs.nixvim = {
      enable = true;
      vimAlias = true;

      clipboard = {
        register = "unnamedplus";
        providers = {
          wl-copy.enable = true;
          xclip.enable = true;
        };
      };

      colorschemes.base16 = {
        enable = true;
        colorscheme = {
          inherit (config.lib.stylix.colors.withHashtag)
            base00 base01 base02 base03 base04 base05 base06 base07
            base08 base09 base0A base0B base0C base0D base0E base0F;
        };
      };

      globals = {
        formatsave = true;
        mapleader = " ";
        maplocalleader = " ";
      };

      opts = {
        breakindent = true;
        hlsearch = false;
        title = true;
        undofile = true;
        updatetime = 100;
      };

      match = {
        ExtraWhitespace = "\\s\\+$";
      };

      highlight = {
        ExtraWhitespace.bg = "red";
      };

      keymaps = [
        # bufferline.nvim
        {
          action = ":Bdelete<CR>";
          key = "<leader>bx";
          mode = "n";
          options = {
            desc = "Close buffer";
            silent = true;
          };
        }
        {
          action = ":BufferLineCycleNext<CR>";
          key = "<leader>bn";
          mode = "n";
          options = {
            desc = "Next buffer";
            silent = true;
          };
        }
        {
          action = ":BufferLineCyclePrev<CR>";
          key = "<leader>bp";
          mode = "n";
          options = {
            desc = "Previous buffer";
            silent = true;
          };
        }
        {
          action = ":BufferLinePick<CR>";
          key = "<leader>bc";
          mode = "n";
          options = {
            desc = "Pick buffer";
            silent = true;
          };
        }
        {
          action = ":BufferLineSortByExtension<CR>";
          key = "<leader>bse";
          mode = "n";
          options = {
            desc = "Sort buffers by extension";
            silent = true;
          };
        }
        {
          action = ":BufferLineSortByDirectory<CR>";
          key = "<leader>bsd";
          mode = "n";
          options = {
            desc = "Sort buffers by directory";
            silent = true;
          };
        }
        {
          action = ":BufferLineMoveNext<CR>";
          key = "<leader>bmn";
          mode = "n";
          options = {
            desc = "Move buffer forwards";
            silent = true;
          };
        }
        {
          action = ":BufferLineMovePrev<CR>";
          key = "<leader>bmp";
          mode = "n";
          options = {
            desc = "Move buffer backwards";
            silent = true;
          };
        }

        # gitsigns.nvim
        {
          action.__raw = ''
            function()
              if vim.wo.diff then vim.cmd.normal(']c')
              else require('gitsigns').next_hunk()
            end
          '';
          key = "]c";
          mode = "n";
          options = {
            desc = "Next hunk [Gitsigns]";
            silent = true;
          };
        }
        {
          action.__raw = ''
            function()
              if vim.wo.diff then vim.cmd.normal('[c')
              else require('gitsigns').prev_hunk()
            end
          '';
          key = "[c";
          mode = "n";
          options = {
            desc = "Previous hunk [Gitsigns]";
            silent = true;
          };
        }
        {
          action.__raw = "require('gitsigns').stage_hunk";
          key = "<leader>hs";
          mode = "n";
          options = {
            desc = "Stage hunk [Gitsigns]";
            silent = true;
          };
        }
        {
          action.__raw = "require('gitsigns').reset_hunk";
          key = "<leader>hr";
          mode = "n";
          options = {
            desc = "Reset hunk [Gitsigns]";
            silent = true;
          };
        }
        {
          action.__raw = "require('gitsigns').stage_buffer";
          key = "<leader>hS";
          mode = "n";
          options = {
            desc = "Stage buffer [Gitsigns]";
            silent = true;
          };
        }
        {
          action.__raw = "require('gitsigns').undo_stage_hunk";
          key = "<leader>hu";
          mode = "n";
          options = {
            desc = "Undo stage hunk [Gitsigns]";
            silent = true;
          };
        }
        {
          action.__raw = "require('gitsigns').reset_buffer";
          key = "<leader>hR";
          mode = "n";
          options = {
            desc = "Reset buffer [Gitsigns]";
            silent = true;
          };
        }
        {
          action.__raw = "require('gitsigns').preview_hunk";
          key = "<leader>hp";
          mode = "n";
          options = {
            desc = "Preview hunk [Gitsigns]";
            silent = true;
          };
        }
        {
          action.__raw = "function() gitsigns.blame_line{full=true} end";
          key = "<leader>hb";
          mode = "n";
          options = {
            desc = "Blame line [Gitsigns]";
            silent = true;
          };
        }
        {
          action.__raw = "require('gitsigns').toggle_current_line_blame";
          key = "<leader>tb";
          mode = "n";
          options = {
            desc = "Toggle blame [Gitsigns]";
            silent = true;
          };
        }
        {
          action.__raw = "require('gitsigns').diffthis";
          key = "<leader>hd";
          mode = "n";
          options = {
            desc = "Diff this [Gitsigns]";
            silent = true;
          };
        }
        {
          action.__raw = "function() require('gitsigns').diffthis(~) end";
          key = "<leader>hD";
          mode = "n";
          options = {
            desc = "Diff project [Gitsigns]";
            silent = true;
          };
        }
        {
          action.__raw = "require('gitsigns').toggle_deleted";
          key = "<leader>td";
          mode = "n";
          options = {
            desc = "Toggle deleted [Gitsigns]";
            silent = true;
          };
        }

        # trouble.nvim
        {
          action = ":Trouble toggle diagnostics<CR>";
          key = "<leader>lwd";
          mode = "n";
          options = {
            desc = "Workspace diagnostics [trouble]";
            silent = true;
          };
        }
        {
          action = ":Trouble toggle diagnostics filter.buf=0<CR>";
          key = "<leader>ld";
          mode = "n";
          options = {
            desc = "Document diagnostics [trouble]";
            silent = true;
          };
        }
        {
          action = ":Trouble toggle lsp_references<CR>";
          key = "<leader>lr";
          mode = "n";
          options = {
            desc = "LSP References [trouble]";
            silent = true;
          };
        }
        {
          action = ":Trouble toggle quickfix<CR>";
          key = "<leader>xq";
          mode = "n";
          options = {
            desc = "QuickFix [trouble]";
            silent = true;
          };
        }
        {
          action = ":Trouble toggle loclist<CR>";
          key = "<leader>xl";
          mode = "n";
          options = {
            desc = "LOCList [trouble]";
            silent = true;
          };
        }
        {
          action = ":Trouble toggle symbols<CR>";
          key = "<leader>xs";
          mode = "n";
          options = {
            desc = "Symbols [trouble]";
            silent = true;
          };
        }
      ];

      plugins = {
        # Utility.
        bufdelete.enable = true;
        comment.enable = true;
        nvim-autopairs.enable = true;
        nvim-surround.enable = true;
        todo-comments.enable = true;

        # Visuals.
        indent-blankline.enable = true;
        nvim-colorizer.enable = true;
        web-devicons.enable = true;

        # UI.
        fastaction.enable = true;
        noice.enable = true;
        notify.enable = true;
        nvim-lightbulb.enable = true;

        # Git.
        fugitive.enable = true;
        gitsigns.enable = true;

        # Tab line.
        bufferline.enable = true;

        # Status line.
        lualine.enable = true;

        # File tree.
        neo-tree.enable = true;

        # Snippets.
        friendly-snippets.enable = true;
        luasnip.enable = true;

        # Telescope.
        telescope = {
          enable = true;
          keymaps = {
            "<leader>ff" = {
              action = "find_files";
              options.desc = "Find files";
            };
            "<leader>fg" = {
              action = "live_grep";
              options.desc = "Live grep";
            };
            "<leader>fb" = {
              action = "buffers";
              options.desc = "Buffers";
            };
            "<leader>fh" = {
              action = "help_tags";
              options.desc = "Help tags";
            };
            "<leader>ft" = {
              action = "";
              options.desc = "Open Telescope";
            };
          };
        };

        # Terminal.
        toggleterm = {
          enable = true;
          settings = {
            direction = "vertical";
            open_mapping = "[[C-t]]";
          };
        };

        # Keybindings.
        which-key = {
          enable = true;
          settings.spec = [
            {
              __unkeyed = "<leader>b";
              group = "+Buffer";
            }
            {
              __unkeyed = "<leader>bm";
              group = "+BufferLineMove";
            }
            {
              __unkeyed = "<leader>bs";
              group = "+BufferLineSort";
            }
            {
              __unkeyed = "<leader>f";
              group = "+Telescope";
            }
            {
              __unkeyed = "<leader>h";
              group = "+Gitsigns";
            }
            {
              __unkeyed = "<leader>l";
              group = "+LSP";
            }
            {
              __unkeyed = "<leader>lw";
              group = "+Workspace";
            }
            {
              __unkeyed = "<leader>x";
              group = "+Trouble";
            }
          ];
        };

        # Autocomplete.
        cmp = {
          enable = true;
          settings = {
            snippet = {
              expand = ''
                function(args)
                  require('luasnip').lsp_expand(args.body)
                end
              '';
            };
            mapping = {
              "<C-Space>" = "cmp.mapping.complete()";
              "<C-e>" = "cmp.mapping.close()";
              "<CR>" = "cmp.mapping.confirm({ select = true })";

              "<Tab>" = ''
                cmp.mapping(function(fallback)                  if cmp.visible() then
                    cmp.select_next_item()
                  elseif luasnip.locally_jumpable(1) then
                    luasnip.jump(1)
                  else
                    fallback()
                  end
                end)
              '';

              "<S-Tab>" = ''
                cmp.mapping(function(fallback)
                  if cmp.visible() then
                    cmp.select_prev_item()
                  elseif luasnip.locally_jumpable(-1) then
                    luasnip.jump(-1)
                  else
                    fallback()
                  end
                end)
              '';
            };
            sources = [
              { name = "nvim_lsp"; }
              { name = "luasnip"; }
              { name = "path"; }
              { name = "buffer"; }
            ];
          };
          cmdline = {
            "/" = {
              mapping.__raw = "cmp.mapping.preset.cmdline()";
              sources = [
                { name = "buffer"; }
              ];
            };
            ":" = {
              mapping.__raw = "cmp.mapping.preset.cmdline()";
              sources = [
                { name = "path"; }
                { name = "cmdline"; }
              ];
            };
          };
        };

        cmp-git.enable = true;

        # Tree-sitter.
        treesitter = {
          enable = true;
          settings = {
            highlight.enable = true;
            indent.enable = true;
          };
        };

        # LSP.
        lsp = {
          enable = true;
          inlayHints = true;
          keymaps = {
            diagnostic = {
              "<leader>lgn" = {
                action = "goto_next";
                options.desc = "Go to next diagnostic";
              };
              "<leader>lgp" = {
                action = "goto_prev";
                options.desc = "Go to previous diagnostic";
              };
              "<leader>le" = {
                action = "open_float";
                options.desc = "Open diagnostic float";
              };
            };
            lspBuf = {
              "<leader>lgd" = {
                action = "definition";
                options.desc = "Go to definition";
              };
              "<leader>lgD" = {
                action = "declaration";
                options.desc = "Go to declaration";
              };
              "<leader>lgt" = {
                action = "type_definition";
                options.desc = "Go to type";
              };
              "<leader>lgi" =  {
                action = "implementation";
                options.desc = "List implementations";
              };
              "<leader>lgr" = {
                action = "references";
                options.desc = "List references";
              };
              "<leader>lH" = {
                action = "document_highlight";
                options.desc = "Document highlight";
              };
              "<leader>lS" = {
                action = "document_symbol";
                options.desc = "Document symbols";
              };
              "<leader>lwa" = {
                action = "add_workspace_folder";
                options.desc = "Add workspace folder";
              };
              "<leader>lwr" = {
                action = "remove_workspace folder";
                options.desc = "Remove workspace folder";
              };
              "<leader>lwl" = {
                action = ''
                  function()
                    vim.notify(vim.inspect(vim.lsp.buf.list_workspace_folders()))
                  end
                '';
                options.desc = "List workspace folders";
              };
              "<leader>lws" = {
                action = "workspace_symbol";
                options.desc = "List workspace symbols";
              };
              "<leader>lh" = {
                action = "hover";
                options.desc = "Trigger hover";
              };
              "<leader>ls" = {
                action = "signature_help";
                options.desc = "Signature help";
              };
              "<leader>ln" = {
                action = "rename";
                options.desc = "Rename symbol";
              };
              "<leader>la" = {
                action = "code_action";
                options.desc = "Code action";
              };
              "<leader>lf" = {
                action = "format";
                options.desc = "Format";
              };
              "<leader>ltf" = {
                action = ''
                  function()
                    vim.b.disableFormatSave = not vim.b.disableFormatSave
                  end
                '';
                options.desc = "Toggle format on save";
              };
            };
          };
          servers = {
            # Nix.
            nil_ls = {
              enable = true;
              settings = {
                formatting.command = [ "${pkgs.nixfmt-rfc-style}/bin/nixfmt" ];
              };
            };
          };
        };

        # Diagnostics.
        trouble.enable = true;

        # LaTeX.
        vimtex = {
          enable = true;
          settings = {
            view_method = "zathura_simple";
          };
        };
      };
    };
  };
}
