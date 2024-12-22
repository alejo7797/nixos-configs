{ pkgs, lib, config, ... }: {

  options.myHome.neovim.deoplete.enable = lib.mkEnableOption "deoplete";

  config = let

    cfg = config.myHome.neovim;

  in lib.mkIf cfg.deoplete.enable {

    programs.neovim.plugins = with pkgs.vimPlugins; [
      {
        plugin = deoplete-nvim;
        config = ''

          " Load deoplete.
          let g:deoplete#enable_at_startup = 1

          " Use ALE as a completion source when available.
          call deoplete#custom#option('sources', {
          \ '_': [${if cfg.ale.enable then "'ale', " else ""}'omni'],
          \})

          " Integrate deoplete with vimtex.
          call deoplete#custom#var('omni', 'input_patterns', {
          \ 'tex': g:vimtex#re#deoplete
          \})

          " Set up <TAB> completion.
          inoremap <expr><TAB> pumvisible() ? "\<C-n>" : "\<TAB>"
          inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<S-TAB>"

        '';
      }
    ];
  };
}
