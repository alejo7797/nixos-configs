{ pkgs, lib, config, ... }:

let
  cfg = config.myHome.neovim.latex;
in

{
  options.myHome.neovim.latex.enable = lib.mkEnableOption "NeoVim LaTeX support";

  config.programs.nvf.settings.vim = lib.mkIf cfg.enable {
    # Install texlab for LSP support.
    extraPackages = with pkgs; [texlab];

    # Configure the LSP client.
    lsp.lspconfig = {
      enable = true;
      sources.texlab = ''
        lspconfig.texlab.setup{}
      '';
    };

    # Install treesitter grammars.
    treesitter.grammars = with pkgs.vimPlugins.nvim-treesitter.builtGrammars; [
      bibtex
      latex
    ];

    # Enable and configure VimTeX.
    extraPlugins = with pkgs.vimPlugins; {
      vimtex = {
        package = vimtex;
        setup = ''
          vim.g.vimtex_view_method = "zathura_simple"
        '';
      };
    };
  };
}
