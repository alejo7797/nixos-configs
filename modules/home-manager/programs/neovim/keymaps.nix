{
  programs.nixvim = {

    keymaps = [

      {
        action = "<ESC>";
        key = "jk";
        mode = "i";
        options = {
          desc = "Exit insert mode";
        };
      }

      {
        action.__raw = ''
          function()
            vim.cmd("update")
          end
        '';
        key = "<C-s>";
        mode = [ "i" "n" ];
        options = {
          desc = "Write to disk";
        };
      }

      {
        action.__raw = ''
          function()
            require("bufdelete").bufdelete(0, false)
          end
        '';
        key = "<leader>bx";
        mode = "n";
        options = {
          desc = "Close buffer";
        };
      }
      {
        action.__raw = ''
          function()
            require("bufferline").cycle(1)
          end
        '';
        key = "]b";
        mode = "n";
        options = {
          desc = "Next buffer";
        };
      }
      {
        action.__raw = ''
          function()
            require("bufferline").cycle(-1)
          end
        '';
        key = "[b";
        mode = "n";
        options = {
          desc = "Previous buffer";
        };
      }
      {
        action.__raw = ''
          function()
            require("bufferline").pick()
          end
        '';
        key = "<leader>bc";
        mode = "n";
        options = {
          desc = "Pick buffer";
        };
      }
      {
        action.__raw = ''
          function()
            require("bufferline").sort_by("directory")
          end
        '';
        key = "<leader>bsd";
        mode = "n";
        options = {
          desc = "Sort buffers by directory";
        };
      }
      {
        action.__raw = ''
          function()
            require("bufferline").sort_by("extension")
          end
        '';
        key = "<leader>bse";
        mode = "n";
        options = {
          desc = "Sort buffers by extension";
        };
      }
      {
        action.__raw = ''
          function()
            require("bufferline").move(1)
          end
        '';
        key = "<leader>bmn";
        mode = "n";
        options = {
          desc = "Move buffer forwards";
        };
      }
      {
        action.__raw = ''
          function()
            require("bufferline").move(-1)
          end
        '';
        key = "<leader>bmp";
        mode = "n";
        options = {
          desc = "Move buffer backwards";
        };
      }

      {
        action.__raw = ''
          function()
            require("neo-tree.command").execute({
              toggle = true,
            })
          end
        '';
        key = "<C-n>";
        mode = "n";
        options = {
          desc = "Toggle Neo-tree";
        };
      }
      {
        action.__raw = ''
          function()
            require("neo-tree.command").execute({
              action = "focus",
            })
          end
        '';
        key = "<leader>e";
        mode = "n";
        options = {
          desc = "Neo-tree";
        };
      }

      {
        action.__raw = ''
          function()
            require("trouble").toggle({
              mode = "diagnostics"
            })
          end
        '';
        key = "<leader>lwd";
        mode = "n";
        options = {
          desc = "Project diagnostics";
        };
      }
      {
        action.__raw = ''
          function()
            require("trouble").toggle({
              mode = "diagnostics",
              filter = {
                buf = 0,
              },
            })
          end
        '';
        key = "<leader>lb";
        mode = "n";
        options = {
          desc = "Buffer diagnostics";
        };
      }
      {
        action.__raw = ''
          function()
            require("trouble").toggle({
              mode = "lsp_references"
            })
          end
        '';
        key = "<leader>lr";
        mode = "n";
        options = {
          desc = "LSP references";
        };
      }
      {
        action.__raw = ''
          function()
            require("trouble").toggle({
              mode = "quickfix"
            })
          end
        '';
        key = "<leader>xq";
        mode = "n";
        options = {
          desc = "Quickfix list";
        };
      }
      {
        action.__raw = ''
          function()
            require("trouble").toggle({
              mode = "loclist"
            })
          end
        '';
        key = "<leader>xl";
        mode = "n";
        options = {
          desc = "Location list";
        };
      }
      {
        action.__raw = ''
          function()
            require("trouble").toggle({
              mode = "symbols"
            })
          end
        '';
        key = "<leader>xs";
        mode = "n";
        options = {
          desc = "Document symbols";
        };
      }

      {
        action.__raw = ''
          function()
            vim.g.disable_autoformat = not vim.g.disable_autoformat
          end
        '';
        key = "<leader>ltf";
        mode = "n";
        options = {
          desc = "Toggle format on save";
        };
      }
      {
        action.__raw = ''
          function()
            require("conform").format({
              lsp_fallback = true,
            })
          end
        '';
        key = "<leader>lf";
        mode = "n";
        options = {
          desc = "Format buffer";
        };
      }
      {
        action.__raw = ''
          function()
            require("conform").format({
              lsp_fallback = true,
            })
          end
        '';
        key = "<leader>lf";
        mode = "x";
        options = {
          desc = "Format selection";
        };
      }

      {
        action.__raw = ''
          function()
            require("todo-comments").jump_next()
          end
        '';
        key = "]t";
        mode = "n";
        options = {
          desc = "Next todo comment";
        };
      }
      {
        action.__raw = ''
          function()
            require("todo-comments").jump_prev()
          end
        '';
        key = "[t";
        mode = "n";
        options = {
          desc = "Previous todo comment";
        };
      }
    ];

    plugins = {

      gitsigns.settings.on_attach.__raw = ''
        function(bufnr)
          local gitsigns = require("gitsigns")

          local function map(mode, l, r, opts)
            opts = opts or {}
            opts.buffer = bufnr
            vim.keymap.set(mode, l, r, opts)
          end

          -- Navigation.
          map("n", "]c", function()
            if vim.wo.diff then
              vim.cmd.normal({ "]c", bang = true })
            else
              gitsigns.nav_hunk("next")
            end
          end, {
            desc = "Next Git hunk",
          })

          map("n", "[c", function()
            if vim.wo.diff then
              vim.cmd.normal({ "[c", bang = true })
            else
              gitsigns.nav_hunk("prev")
            end
          end, {
            desc = "Previous Git hunk",
          })

          -- Actions.
          map("n", "<leader>hs", gitsigns.stage_hunk, {
            desc = "Stage hunk",
          })
          map("n", "<leader>hu", gitsigns.undo_stage_hunk, {
            desc = "Undo stage hunk",
          })
          map("n", "<leader>hr", gitsigns.reset_hunk, {
            desc = "Reset hunk",
          })

          map("v", "<leader>hs", function()
            gitsigns.stage_hunk({ vim.fn.line("."), vim.fn.line("v") })
          end, {
            desc = "Stage hunk",
          })

          map("v", "<leader>hr", function()
            gitsigns.reset_hunk({ vim.fn.line("."), vim.fn.line("v") })
          end, {
            desc = "Reset hunk",
          })

          map("n", "<leader>hS", gitsigns.stage_buffer, {
            desc = "Stage buffer",
          })
          map("n", "<leader>hR", gitsigns.reset_buffer, {
            desc = "Reset buffer",
          })
          map("n", "<leader>hp", gitsigns.preview_hunk, {
            desc = "Preview hunk",
          })
          map("n", "<leader>hi", gitsigns.preview_hunk_inline, {
            desc = "Preview inline",
          })

          map("n", "<leader>hb", function()
            gitsigns.blame_line({ full = true })
          end, {
            desc = "Blame line",
          })

          map("n", "<leader>hd", gitsigns.diffthis, {
            desc = "Diff buffer",
          })

          map("n", "<leader>hD", function()
            gitsigns.diffthis("~")
          end, {
            desc = "Diff project",
          })

          -- Toggles.
          map("n", "<leader>tb", gitsigns.toggle_current_line_blame, {
            desc = "Toggle line blame",
          })
          map("n", "<leader>td", gitsigns.toggle_deleted, {
            desc = "Toggle deleted",
          })
          map("n", "<leader>tw", gitsigns.toggle_word_diff, {
            desc = "Toggle word diff",
          })

          -- Text object.
          map({ "o", "x" }, "ih", gitsigns.select_hunk, {
            desc = "git hunk",
          })
        end
      '';

      telescope.keymaps = {
        "<leader>fb" = {
          action = "buffers";
          options = {
            desc = "Telescope open buffers";
          };
        };
        "<leader>fc" = {
          action = "git_commits";
          options = {
            desc = "Telescope Git commits";
          };
        };
        "<leader>ff" = {
          action = "find_files";
          options = {
            desc = "Telescope project files";
          };
        };
        "<leader>fg" = {
          action = "live_grep";
          options = {
            desc = "Telescope live grep";
          };
        };
        "<leader>fh" = {
          action = "help_tags";
          options = {
            desc = "Telescope help pages";
          };
        };
        "<leader>fo" = {
          action = "oldfiles";
          options = {
            desc = "Telescope old files";
          };
        };
        "<leader>fs" = {
          action = "git_status";
          options = {
            desc = "Telescope Git status";
          };
        };
        "<leader>fz" = {
          action = "current_buffer_fuzzy_find";
          options = {
            desc = "Telescope this buffer";
          };
        };
      };

      which-key = {
        enable = true;
        settings = {
          preset = "modern";
          win.border = "rounded";
          spec = [
            {
              __unkeyed = "<leader>b";
              group = "+Buffers";
            }
            {
              __unkeyed = "<leader>bm";
              group = "+Move buffers";
            }
            {
              __unkeyed = "<leader>bs";
              group = "+Sort buffers";
            }
            {
              __unkeyed = "<leader>e";
              icon = {
                icon = "󰙅";
                color = "yellow";
              };
            }
            {
              __unkeyed = "<leader>f";
              group = "+Telescope";
            }
            {
              __unkeyed = "<leader>h";
              group = "+Gitsigns";
              icon = {
                cat = "filetype";
                name = "git";
              };
            }
            {
              __unkeyed = "<leader>hb";
              icon = {
                cat = "filetype";
                name = "git";
              };
            }
            {
              __unkeyed = "<leader>hd";
              icon = {
                cat = "filetype";
                name = "git";
              };
            }
            {
              __unkeyed = "<leader>hD";
              icon = {
                cat = "filetype";
                name = "git";
              };
            }
            {
              __unkeyed = "<leader>hi";
              icon = {
                cat = "filetype";
                name = "git";
              };
            }
            {
              __unkeyed = "<leader>hp";
              icon = {
                cat = "filetype";
                name = "git";
              };
            }
            {
              __unkeyed = "<leader>hr";
              icon = {
                cat = "filetype";
                name = "git";
              };
            }
            {
              __unkeyed = "<leader>hR";
              icon = {
                cat = "filetype";
                name = "git";
              };
            }
            {
              __unkeyed = "<leader>hs";
              icon = {
                cat = "filetype";
                name = "git";
              };
            }
            {
              __unkeyed = "<leader>hS";
              icon = {
                cat = "filetype";
                name = "git";
              };
            }
            {
              __unkeyed = "<leader>hu";
              icon = {
                cat = "filetype";
                name = "git";
              };
            }
            {
              __unkeyed = "<leader>l";
              group = "+LSP";
              icon = {
                icon = " ";
                color = "cyan";
              };
            }
            {
              __unkeyed = "<leader>lb";
              icon = {
                icon = "󱖫 ";
                color = "green";
              };
            }
            {
              __unkeyed = "<leader>lf";
              icon = {
                icon = " ";
                color = "cyan";
              };
            }
            {
              __unkeyed = "<leader>ln";
              icon = {
                icon = "󰑕";
                color = "cyan";
              };
            }
            {
              __unkeyed = "<leader>lg";
              group = "+Go to";
              icon = {
                icon = "󱞷";
                color = "cyan";
              };
            }
            {
              __unkeyed = "<leader>lH";
              icon = {
                icon = " ";
                color = "cyan";
              };
            }
            {
              __unkeyed = "<leader>lh";
              icon = {
                icon = " ";
                color = "cyan";
              };
            }
            {
              __unkeyed = "<leader>lr";
              icon = {
                icon = " ";
                color = "cyan";
              };
            }
            {
              __unkeyed = "<leader>lS";
              icon = {
                icon = " ";
                color = "cyan";
              };
            }
            {
              __unkeyed = "<leader>ls";
              icon = {
                icon = " ";
                color = "cyan";
              };
            }
            {
              __unkeyed = "<leader>lt";
              icon = {
                icon = " ";
                color = "cyan";
              };
            }
            {
              __unkeyed = "<leader>lw";
              group = "+Workspace";
              icon = {
                icon = "󰉋 ";
                color = "blue";
              };
            }
            {
              __unkeyed = "<leader>t";
              group = "+Toggle";
              icon = {
                cat = "filetype";
                name = "git";
              };
            }
            {
              __unkeyed = "<leader>tb";
              icon = {
                cat = "filetype";
                name = "git";
              };
            }
            {
              __unkeyed = "<leader>td";
              icon = {
                cat = "filetype";
                name = "git";
              };
            }
            {
              __unkeyed = "<leader>tw";
              icon = {
                cat = "filetype";
                name = "git";
              };
            }
            {
              __unkeyed = "<leader>x";
              group = "+Trouble";
              icon = {
                icon = "󰙅";
                color = "red";
              };
            }
            {
              __unkeyed = "]c";
              icon = {
                cat = "filetype";
                name = "git";
              };
            }
            {
              __unkeyed = "[c";
              icon = {
                cat = "filetype";
                name = "git";
              };
            }
            {
              __unkeyed = "]d";
              desc = "Next diagnostic";
            }
            {
              __unkeyed = "[d";
              desc = "Previous diagnostic";
            }
            {
              __unkeyed = "]t";
              icon = {
                icon = "󰝖 ";
                color = "purple";
              };
            }
            {
              __unkeyed = "[t";
              icon = {
                icon = "󰝖 ";
                color = "purple";
              };
            }
            {
              __unkeyed = "<C-n>";
              icon = {
                icon = "󰙅";
                color = "yellow";
              };
            }
          ];
        };
      };

      cmp.settings.mapping = {
        # Scroll the current suggestion's info.
        "<C-b>".__raw = "cmp.mapping.scroll_docs(-4)";
        "<C-f>".__raw = "cmp.mapping.scroll_docs(4)";

        # Scroll between completion suggestions.
        "<C-p>".__raw = "cmp.mapping.select_prev_item()";
        "<C-n>".__raw = "cmp.mapping.select_next_item()";

        # To close the autosuggestion menu.
        "<C-e>".__raw = "cmp.mapping.abort()";
        "<CR>".__raw = "cmp.mapping.close()";

        "<Tab>".__raw = ''
          cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.confirm({select = true})
            elseif luasnip.jumpable(1) then
              luasnip.jump(1)
            else
              fallback()
            end
          end, { "i", "s" })
        '';

        "<S-Tab>".__raw = ''
          cmp.mapping(function(fallback)
            if luasnip.jumpable(-1) then
              luasnip.jump(-1)
            else
              fallback()
            end
          end, { "i", "s" })
        '';
      };

      lsp.keymaps = {
        diagnostic = {
          "<leader>lgn" = {
            action = "goto_next";
            desc = "Next diagnostic";
          };
          "<leader>lgp" = {
            action = "goto_prev";
            desc = "Previous diagnostic";
          };
          "<leader>le" = {
            action = "open_float";
            desc = "Diagnostics float";
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
        };
      };
    };
  };
}
