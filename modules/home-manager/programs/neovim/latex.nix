{ lib, pkgs, ... }:

{
  programs.nixvim = {

    globals = {

      # Better syntax highlighting.
      matchup_override_vimtex = 1;

    };

    plugins = {

      # Settings for the TeX language server.
      lsp.servers.texlab.settings.texlab = {

        chktex = {
          # Enable regular linting of TeX files.
          onEdit = true; onOpenAndSave = true;
        };

        inlayHints = {
          # Distracts source code.
          labelReferences = false;
        };

        latexindent = {
          # Enables line wrapping.
          modifyLineBreaks = true;
        };

      };

      nvim-autopairs = {

        luaConfig.post = lib.concatMapStrings
          (left: ''
            npairs.get_rule("${left}")
              :with_pair(cond.not_before_text("\\"))
          '')
          [
            "(" "[" "{"
          ];

      };

      treesitter.settings = {

        # See :h vimtex-faq-treesitter.
        highlight.disable = [ "latex" ];

      };

      vimtex = {

        # Avoid missing package issues.
        texlivePackage = pkgs.texliveFull;

        settings = {

          # Use keybinding `ts$`.
          env_toggle_math_map = {

            "\\(" = "\\["; # inline -> display
            "align" = "equation"; # -> add label
            "equation" = "\\("; # -> closes loop
            "\\[" = "align*"; # -> multi-line

            # Fallback.
            "$$" = "\\[";
            "$" = "\\(";

          };

          delim_toggle_mod_list = [
            # Toggle delim size.
            [ "\\left" "\\right" ]
            [ "\\big" "\\big" ]
          ];

          # Don't spell check comments.
          syntax_nospell_comments = 1;

          # Use Zathura for viewing PDFs.
          view_method = "zathura_simple";

        };

      };
    };
  };
}
