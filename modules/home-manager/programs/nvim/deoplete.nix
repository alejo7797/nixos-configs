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

          " Configure the available completion sources.
          call deoplete#custom#option('sources', {
          \ '_': ['ale', 'omni', 'around', 'buffer', 'file'],
          \})

          " Integrate vimtex with deoplete.
          call deoplete#custom#var('omni', 'input_patterns', {
          \ 'tex': g:vimtex#re#deoplete
          \})

          " Set up <TAB> completion.
          inoremap <silent><expr> <TAB>
          \ pumvisible() ? "\<C-n>" :
          \ <SID>check_back_space() ? "\<Tab>" :
          \ deoplete#can_complete() ? deoplete#complete() : '''

          function! s:check_back_space() abort
            let col = col('.') - 1
            return !col || getline('.')[col - 1]  =~# '\s'
          endfunction

          " Move up completion results with <S-TAB>.
          inoremap <silent><expr> <S-TAB>
          \ pumvisible() ? "\<C-p>" : "\<S-TAB>"

          " Use <CR> to accept completions.
          inoremap <silent> <CR> <C-r>=<SID>my_cr_function()<CR>

          function! s:my_cr_function()
            return deoplete#mappings#smart_close_popup() . "\<CR>"
          endfunction

        '';
      }
      {
        plugin = neosnippet;
        config = ''

          " Enable snipMate compatibility feature.
          let g:neosnippet#enable_snipmate_compatibility = 1

          " Tell Neosnippet where to find more snippets.
          let g:neosnippet#snippets_directory='${pkgs.vimPlugins.vim-snippets}/snippets'

        '';
      }
    ];
  };
}
