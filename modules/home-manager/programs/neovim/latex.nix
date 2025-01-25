{ pkgs, ... }:

{
  programs.nixvim.plugins = {

    nvim-autopairs.luaConfig.post = ''

      local rule = require('nvim-autopairs.rule')
      require('nvim-autopairs').add_rules({

        rule("$ ", " $", "tex"),

        rule("\\(", "\\)", "tex"),
        rule("\\{", "\\}", "tex"),
        rule("\\[", "\\]", "tex"),

        rule("\\left(", "\\right)", "tex"),
        rule("\\left\\{", "\\right\\}", "tex"),
        rule("\\left[", "\\right]", "tex"),

      })
    '';

    lsp.servers = {
      texlab = {
        enable = true;
        settings.texlab = {
          bibtexFormatter = "texlab";
          chktex = {
            onEdit = true;
            onOpenAndSave = true;
          };
          latexFormatter = "latexindent";
          latexindent.local = pkgs.writeText "latexindent.yaml" ''
            defaultIndent: "    "
          '';
        };
      };
    };

    vimtex = {
      enable = true;
      texlivePackage = pkgs.texliveFull;
      settings = {
        view_method = "zathura_simple";
      };
    };

    which-key.settings = {
      disable.ft = [ "tex" ];
    };
  };
}
