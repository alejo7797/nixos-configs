{ pkgs, ... }:

{
  programs.nixvim.plugins = {

    nvim-autopairs.luaConfig.post = ''

      local rule = require('nvim-autopairs.rule')
      require('nvim-autopairs').add_rules({

        rule("$ ", " $", "tex"),

        rule("\\(", "\\)", "tex"),
        rule("\\left(", "\\right)", "tex"),

        rule("\\[", "\\]", "tex"),
        rule("\\left[", "\\right]", "tex"),

        rule("\\{", "\\}", "tex"),
        rule("\\left\\{", "\\right\\}", "tex"),

        rule("\\langle", "\\rangle", "tex"),
        rule("\\left\\langle", "\\right\\rangle", "tex"),

      })

    '';

    lsp.servers = {
      texlab = {
        enable = true;
        settings.texlab = {
          bibtexFormatter = "texlab";
          chktex = { onEdit = true; onOpenAndSave = true; };
          latexindent = { modifyLineBreaks = true; };
          inlayHints.labelReferences = false;
        };
      };
    };

    vimtex = {
      enable = true;
      texlivePackage = pkgs.texliveFull;
      settings = { view_method = "zathura_simple"; };
    };
  };
}
