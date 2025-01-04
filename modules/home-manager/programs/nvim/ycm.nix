{ pkgs, lib, config, ... }: let

  cfg = config.myHome.neovim.ycm;

in {

  options.myHome.neovim.ycm.enable = lib.mkEnableOption "YouCompleteMe";

  config = lib.mkIf cfg.enable {

    # Disable nvim-cmp.
    myHome.neovim.nvim-cmp.enable = false;

    programs.neovim.plugins = with pkgs.vimPlugins; [
      {
        plugin = YouCompleteMe;
        config = ''
          " VimTex integration.
          if !exists('g:ycm_semantic_triggers')
            let g:ycm_semantic_triggers = {}
          endif
          au VimEnter * let g:ycm_semantic_triggers.tex=g:vimtex#re#youcompleteme
        '';
      }
    ];
  };
}
