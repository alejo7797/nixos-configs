{ pkgs, lib, config, ... }: {

  options.myHome.neovim.ycm.enable = lib.mkEnableOption "YouCompleteMe";

  config = let

    cfg = config.myHome.neovim;

  in lib.mkIf cfg.ycm.enable {

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
      {
        plugin = ultisnips;
        config = ''

          " Change the default keymappings.
          let g:UltiSnipsExpandTrigger="<C-k>"
          let g:UltiSnipsJumpForwardTrigger="<C-k>"
          let g:UltiSnipsJumpBackwardTrigger="<C-j>"

        '';
      }
    ];
  };
}
