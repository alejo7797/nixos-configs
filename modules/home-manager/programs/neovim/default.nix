{
  lib,
  config,
  pkgs,
  ...
}:

let
  cfg = config.myHome.neovim;
  stylix-colors = config.lib.stylix.colors.withHashtag;
in

{
  options.myHome.neovim.enable = lib.mkEnableOption "Neovim";

  config = lib.mkIf cfg.enable {

    # Load our personal snippets.
    xdg.configFile."nvim/snippets".source = ./snippets;

    programs.nixvim = {
      enable = true;
      vimAlias = true;

      extraPackages = with pkgs; [ fd ];

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
        mapleader = " ";
        maplocalleader = " ";
      };

      opts = {
        autochdir = true;
        breakindent = true;
        expandtab = true;
        foldlevelstart = 99;
        hlsearch = false;
        shiftwidth = 4;
        signcolumn = "yes";
        title = true;
        undofile = true;
        updatetime = 100;
      };

      highlightOverride = with stylix-colors; {

        MiniIconsBlue.fg = base0D;
        MiniIconsGrey.fg = base04;
        LightBulbSign.bg = base00;

        GitSignsAdd = {
          fg = base0B;
          bg = base00;
        };
        GitSignsChange = {
          fg = base0E;
          bg = base00;
        };
        GitSignsDelete = {
          fg = base08;
          bg = base00;
        };
        GitSignsUntracked = {
          fg = base0C;
          bg = base00;
        };

        NormalFloat.bg = base00;
        WhichKeyGroup.fg = base05;
        WhichKeySeparator.bg = base00;

        MatchParen = {
          fg = base0A;
          bg = base02;
        };
        SignColumn = {
          fg = base04;
          bg = base00;
        };
        WinSeparator = {
          fg = base05;
          bg = base00;
        };
      };

      autoCmd = [
        {
          event = "FileType";
          pattern = [ "nix" ];
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
        nvim-autopairs.enable = true;
        nvim-surround.enable = true;
        todo-comments.enable = true;
        trim.enable = true;

        # Visuals.
        indent-blankline.enable = true;
        nvim-colorizer.enable = true;
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
              function()
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
          filesystem = {
            useLibuvFileWatcher = true;
          };
        };

        # Snippets.
        friendly-snippets.enable = true;
        luasnip = {
          enable = true;
          # Load custom snippets.
          fromSnipmate = [ { } ];
        };

        # Telescope.
        telescope.enable = true;

        # Terminal.
        toggleterm = {
          enable = true;
          settings = {
            direction = "vertical";
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
          settings = {
            snippet = {
              expand = ''
                function(args)
                  require('luasnip').lsp_expand(args.body)
                end
              '';
            };
            sources = [
              { name = "nvim_lsp"; }
              { name = "luasnip"; }
              { name = "path"; }
              { name = "buffer"; }
            ];
            window = {
              completion.border = "rounded";
              documentation.border = "rounded";
            };
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
              checkmake.enable = true;
              deadnix.enable = true;
              mypy.enable = true;
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

        trouble.enable = true;
      };
    };
  };
}
