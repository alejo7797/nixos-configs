{
  programs.nixvim = {
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
            if vim.wo.diff then
              vim.cmd.normal({']c', bang = true})
            else
              require('gitsigns').next_hunk()
            end
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
            if vim.wo.diff then
              vim.cmd.normal({'[c', bang = true})
            else
              require('gitsigns').prev_hunk()
            end
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
        action.__raw = "function() require('gitsigns').blame_line{full=true} end";
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
        action.__raw = "function() require('gitsigns').diffthis('~') end";
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

      # lspconfig
      {
        action = ":FormatToggle <CR>";
        key = "<leader>ltf";
        mode = "n";
        options = {
          desc = "Toggle format on save";
          silent = true;
        };
      }
      {
        action.__raw = "vim.lsp.buf.format";
        key = "<leader>lf";
        mode = "v";
        options = {
          desc = "Format selection";
          silent = true;
        };
      }
      {
        action.__raw = ''
          function()
            vim.notify(vim.inspect(vim.lsp.buf.list_workspace_folders()))
          end
        '';
        key = "<leader>lwl";
        options = {
          desc = "List workspace folders";
          silent = true;
        };
      }
    ];

    plugins = {

      telescope.keymaps = {
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

      which-key.settings.spec = [
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
          __unkeyed = "<leader>lr";
          desc = "LSP References [trouble]";
          icon = {
            icon = "󱖫 ";
            color = "green";
          };
        }
        {
          __unkeyed = "<leader>lw";
          group = "+Workspace";
          icon = {
            icon = " ";
            color = "blue";
          };
        }
        {
          __unkeyed = "<leader>x";
          group = "+Trouble";
          icon = {
            icon = "󱖫 ";
            color = "green";
          };
        }
      ];

      cmp.settings.mapping = {
        "<C-Space>" = "cmp.mapping.complete()";
        "<C-e>" = "cmp.mapping.close()";
        "<CR>" = "cmp.mapping.confirm({ select = true })";

        "<Tab>" = ''
          cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_next_item()
            elseif require('luasnip').locally_jumpable(1) then
              require('luasnip').jump(1)
            else
              fallback()
            end
          end)
        '';

        "<S-Tab>" = ''
          cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_prev_item()
            elseif require('luasnip').locally_jumpable(-1) then
              require('luasnip').jump(-1)
            else
              fallback()
            end
          end)
        '';
      };

      lsp.keymaps = {
        diagnostic = {
          "<leader>lgn" = {
            action = "goto_next";
            desc = "Go to next diagnostic";
          };
          "<leader>lgp" = {
            action = "goto_prev";
            desc = "Go to previous diagnostic";
          };
          "<leader>le" = {
            action = "open_float";
            desc = "Open diagnostic float";
          };
        };
        lspBuf = {
          "<leader>lgd" = {
            action = "definition";
            desc = "Go to definition";
          };
          "<leader>lgD" = {
            action = "declaration";
            desc = "Go to declaration";
          };
          "<leader>lgt" = {
            action = "type_definition";
            desc = "Go to type";
          };
          "<leader>lgi" = {
            action = "implementation";
            desc = "List implementations";
          };
          "<leader>lgr" = {
            action = "references";
            desc = "List references";
          };
          "<leader>lH" = {
            action = "document_highlight";
            desc = "Document highlight";
          };
          "<leader>lS" = {
            action = "document_symbol";
            desc = "Document symbols";
          };
          "<leader>lwa" = {
            action = "add_workspace_folder";
            desc = "Add workspace folder";
          };
          "<leader>lwr" = {
            action = "remove_workspace_folder";
            desc = "Remove workspace folder";
          };
          "<leader>lws" = {
            action = "workspace_symbol";
            desc = "List workspace symbols";
          };
          "<leader>lh" = {
            action = "hover";
            desc = "Trigger hover";
          };
          "<leader>ls" = {
            action = "signature_help";
            desc = "Signature help";
          };
          "<leader>ln" = {
            action = "rename";
            desc = "Rename symbol";
          };
          "<leader>la" = {
            action = "code_action";
            desc = "Code action";
          };
          "<leader>lf" = {
            action = "format";
            desc = "Format";
          };
        };
      };
    };
  };
}
