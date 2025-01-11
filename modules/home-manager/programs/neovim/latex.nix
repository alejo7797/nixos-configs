{ pkgs, ... }:

{
  programs.nixvim.plugins = {

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
      settings = {
        view_method = "zathura_simple";
      };
    };

    which-key.settings = {
      disable.ft = [ "tex" ];
    };
  };
}
