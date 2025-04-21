{ pkgs, ... }:

{
  programs.nixvim.plugins = {

    nvim-autopairs.luaConfig.post = ''

      local rule = require('nvim-autopairs.rule')
      require('nvim-autopairs').add_rules({

        -- Inline math environment.
        rule("\\(", "\\)", "tex"),

        -- Display math environment.
        rule("\\[", "\\]", "tex"),

        rule("\\left(", "\\right)", "tex"),
        rule("\\left\\{", "\\right\\}", "tex"),
        rule("\\left[", "\\right]", "tex"),

        -- More LaTeX delimiters.
        rule("\\langle", "\\rangle", "tex"),
        rule("\\{", "\\}", "tex"),

      })

    '';

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

        # Use Zathura for viewing PDFs.
        view_method = "zathura_simple";

      };

    };
  };
}
