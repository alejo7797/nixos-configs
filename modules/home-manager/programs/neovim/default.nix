{ config, inputs, pkgs, ... }:

let
  stylix-colors = config.lib.stylix.colors.withHashtag;
in

{
  imports = [
    inputs.nixvim.homeManagerModules.nixvim
  ];

  programs.nixvim = {
    vimAlias = true;

    extraPackages = with pkgs; [ fd ];

    extraPlugins = with pkgs.vimPlugins; [ aw-watcher-nvim ];

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
        inherit (stylix-colors)
          base00 base01 base02 base03 base04 base05 base06 base07
          base08 base09 base0A base0B base0C base0D base0E base0F;
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
            local npairs = require('nvim-autopairs')
            local rule = require('nvim-autopairs.rule')
          '';
          post = ''
            npairs.add_rules({
              rule(" = {", "};", "nix"),
            })
          '';
        };
      };
      nvim-surround.enable = true;
      todo-comments.enable = true;
      trim.enable = true;

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
      gitsigns.enable = true;

      # Tab line.
      bufferline = {
        enable = true;
        settings.options = {
          close_command.__raw = ''
            function(bufnum)
              require('bufdelete').bufdelete(bufnum, false)
            end
          '';
          left_mouse_command = "buffer %d";
          right_mouse_command = "vertical sbuffer %d";
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
          size = ''
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
          local luasnip = require('luasnip')
        '';
        settings = {
          snippet = {
            expand = ''
              function(args)
                luasnip.lsp_expand(args.body)
              end
            '';
          };
          window = {
            completion.border = "rounded";
            documentation.border = "rounded";
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
          highlight = {
            enable = true;
            disable = [ "latex" ];
          };
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

          # Shellscript.
          bashls.enable = true;

          # C/C++.
          clangd.enable = true;

          # Javascript.
          ts_ls.enable = true;

          # Nix.
          nil_ls = {
            enable = true;
            settings = {
              formatting.command = [ "${pkgs.nixfmt-rfc-style}/bin/nixfmt" ];
              nix.flake.autoArchive = true;
            };
          };
        };
      };

      lsp-format = {
        enable = true;
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
            zsh.enable = true;
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
    };

    extraConfigLua = ''
      require('aw_watcher').setup {}
    '';
  };
}
