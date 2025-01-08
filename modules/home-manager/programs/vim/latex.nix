{
  pkgs,
  config,
  lib,
  ...
}:

let
  cfg = config.myHome.neovim.latex;
in

with pkgs.vimPlugins;

{
  options.myHome.neovim.latex.enable = lib.mkEnableOption "NeoVim LaTeX support";

  config.programs.nvf.settings.vim = lib.mkIf cfg.enable {
    # Install texlab for LSP support.
    extraPackages = with pkgs; [ texlab ];

    # Configure the LSP client.
    lsp.lspconfig = {
      enable = true;
      sources.texlab = "lspconfig.texlab.setup{}";
    };

    # Install treesitter grammars.
    treesitter = {
      enable = true;
      grammars = with nvim-treesitter.builtGrammars; [
        bibtex
        latex
      ];
    };

    # Install VimTeX.
    startPlugins = [ vimtex ];

    # Configure VimTeX.
    extraPlugins.vimtex = {
      package = vimtex;
      setup = "vim.g.vimtex_view_method = 'zathura_simple'";
    };
  };
}
