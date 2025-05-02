{ lib, inputs, pkgs, ... }:

{
  imports = [
    inputs.nixvim.homeManagerModules.nixvim
  ];

  programs.nixvim = {
    vimAlias = true;

    extraPackages = with pkgs; [ fd ];

    clipboard = {
      register = "unnamedplus";
      providers = {
        wl-copy.enable = true;
        xclip.enable = true;
      };
    };

    globals = {
      # Set leader key.
      maplocalleader = " ";
      mapleader = " ";
    };

    opts = {
      # Tab options.
      expandtab = true;
      shiftwidth = 4;

      # Location.
      number = true;
      scrolloff = 8;
      rnu = true;

      breakindent = true;
      foldlevelstart = 99;
      signcolumn = "yes";
      splitright = true;

      # Window title.
      title = true;

      # Search options.
      hlsearch = false;
      ignorecase = true;
      smartcase = true;

      # Persistent undo.
      undofile = true;

      # More responsive.
      updatetime = 100;

      # Keep project spell files.
      spellfile = "en.utf-8.add";
    };

    autoCmd = [
      {
        event = "FileType";
        pattern = [ "c" "lua" "nix" ];
        callback.__raw = ''
          function(opts)
            local bo = vim.bo[opts.buf]
            bo.tabstop = 2
            bo.shiftwidth = 2
            bo.softtabstop = 2
          end
        '';
      }
    ];

    plugins = {

      # Utility.
      bufdelete.enable = true;
      comment.enable = true;
      hex.enable = true;
      lastplace.enable = true;
      nvim-autopairs = {
        enable = true;
        luaConfig = {
          pre = ''
            local npairs = require("nvim-autopairs")
            local rule = require("nvim-autopairs.rule")
          '';
          post = ''
            npairs.add_rules({
              rule(" = ", ";", "nix")
                :with_pair(function(opts)
                  if opts.line:match(";$") then
                    return false
                  else
                    return true
                  end
                end),
            })
          '';
        };
      };
      nvim-surround.enable = true;
      todo-comments.enable = true;
      trim.enable = true;
      vim-matchup = {
        enable = true;
        matchParen = {
          enable = true;
          deferred.enable = true;
          hiSurroundAlways = true;
        };
        treesitterIntegration.enable = true;
      };

      # Visuals.
      indent-blankline.enable = true;
      nvim-colorizer = {
        enable = true;
        userDefaultOptions = {
          css = true;
          names = false;
          RGB = false;
        };
      };
      web-devicons.enable = true;

      # UI.
      fastaction = {
        enable = true;
        settings = {
          register_ui_select = true;
        };
      };
      noice = {
        enable = true;
        settings = {
          lsp.override = {
            "cmp.entry.get_documentation" = true;
            "vim.lsp.util.convert_input_to_markdown_lines" = true;
            "vim.lsp.util.stylize_markdown" = true;
          };
          presets = {
            bottom_search = true;
            command_palette = true;
            long_message_to_split = true;
            lsp_doc_border = true;
          };
          routes = [
            {
              filter = {
                event = "msg_show";
                kind = "";
                find = "written";
              };
              opts = {
                skip = true;
              };
            }
          ];
        };
      };
      notify.enable = true;
      nui.enable = true;

      # Git.
      fugitive.enable = true;
      git-conflict.enable = true;
      gitsigns = {
        enable = true;
        settings = {
          preview_config = {
            border = "rounded";
          };
        };
      };

      # Tab line.
      bufferline = {
        enable = true;
        settings.options = {
          close_command.__raw = ''
            function(bufnum)
              require("bufdelete").bufdelete(bufnum, false)
            end
          '';
          diagnostics = "nvim_lsp";
          diagnostics_indicator.__raw = ''
            function(count, level, diagnostics_dict, context)
              local s = " "
                for e, n in pairs(diagnostics_dict) do
                  local sym = e == "error" and "   "
                    or (e == "warning" and "   " or "  " )
                  s = s .. n .. sym
                end
              return s
            end
          '';
          left_mouse_command = "buffer %d";
          numbers.__raw = ''
            function(opts)
              return string.format('%s·%s', opts.raise(opts.id), opts.lower(opts.ordinal))
            end
          '';
          offsets = [
            {
              filetype = "neo-tree";
              highlight = "Comment";
              separator = true;
              text = "File Explorer";
              text_align = "center";
            }
          ];
          right_mouse_command = "vertical sbuffer %d";
          style_preset.__raw = "require('bufferline').style_preset.minimal";
        };
      };

      # Status line.
      lualine = {
        enable = true;
        settings = {
          options = {
            globalstatus = true;
          };
        };
      };

      # File tree.
      neo-tree = {
        enable = true;
        closeIfLastWindow = true;
        filesystem = {
          useLibuvFileWatcher = true;
        };
      };

      # Telescope.
      telescope.enable = true;

      # Terminal.
      toggleterm = {
        enable = true;
        settings = {
          direction = "horizontal";
          open_mapping = "[[<C-t>]]";
          size.__raw = ''
            function(term)
              if term.direction == "horizontal" then
                return 15
              elseif term.direction == "vertical" then
                return vim.o.columns * 0.4
              end
            end
          '';
        };
      };

      # Keybindings.
      which-key = {
        enable = true;
        settings = {
          preset = "modern";
          win.border = "rounded";
        };
      };

      # Autocomplete.
      cmp = {
        enable = true;
        luaConfig.pre = ''
          local luasnip = require("luasnip")
        '';
        settings = {
          snippet = {
            expand.__raw = ''
              function(args)
                luasnip.lsp_expand(args.body)
              end
            '';
          };
          window = {
            completion.__raw = "cmp.config.window.bordered()";
            documentation.__raw = "cmp.config.window.bordered()";
          };
          sources = [
            {
              name = "nvim_lsp";
              group_index = 1;
            }
            {
              name = "luasnip";
              group_index = 1;
            }
            {
              name = "buffer";
              group_index = 2;
            }
          ];
        };
        filetype = {
          gitcommit.sources = [
            {
              name = "git";
              group_index = 1;
            }
            {
              name = "buffer";
              group_index = 2;
            }
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
              {
                name = "path";
                group_index = 1;
              }
              {
                name = "cmdline";
                group_index = 2;
              }
            ];
            matching.disallow_symbol_nonprefix_matching = false;
          };
        };
      };

      treesitter = {
        enable = true;
        folding = true;
        settings = {
          highlight.enable = true;
          indent.enable = true;
        };
      };

      treesitter-textobjects.enable = true;

      lsp = {
        enable = true;
        inlayHints = true;
        servers = {
          # Python.
          basedpyright.enable = true;
          ruff.enable = true;

          # C/C++.
          clangd.enable = true;

          # Javascript.
          ts_ls.enable = true;

          # Nix.
          nil_ls = {
            enable = true;
            settings = {
              formatting.command = [ "${lib.getExe pkgs.nixfmt-rfc-style}" ];
              nix.flake.autoArchive = true;
            };
          };
        };
      };

      conform-nvim = {
        enable = true;
        settings.format_on_save = ''
          function(bufnr)
            if vim.g.disable_autoformat then
              return
            else
              return { lsp_fallback = true }
            end
          end
        '';
      };

      none-ls = {
        enable = true;
        settings = {
          diagnostics_format = "[#{m}] #{s} (#{c})";
        };
        sources = {
          diagnostics = {
            deadnix.enable = true;
            phpcs.enable = true;
            rubocop.enable = true;
            selene.enable = true;
            statix.enable = true;
            yamllint.enable = true;
          };
          formatting = {
            phpcsfixer.enable = true;
            prettier = {
              enable = true;
              # Prevent conflicts with ts_ls.
              disableTsServerFormatter = true;
            };
            rubocop.enable = true;
            stylua.enable = true;
          };
        };
      };

      nvim-lightbulb = {
        enable = true;
        settings = {
          autocmd.enabled = true;
        };
      };

      project-nvim.enable = true;

      trouble.enable = true;

      lean = {
        mappings = true;
      };
    };
  };
}
