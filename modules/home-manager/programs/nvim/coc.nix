{ pkgs, lib, config, ... }: let

  cfg = config.myHome.neovim.coc;

in {

  options.myHome.neovim.coc.enable = lib.mkEnableOption "coc";

  config = lib.mkIf cfg.enable {

    # Disable nvim-cmp.
    myHome.neovim.nvim-cmp.enable = false;

    # Disable UltiSnips.
    myHome.neovim.ultisnips.enable = false;

    programs.neovim = {

      coc = {
        enable = true;

        # Sensible Coc configuration.
        pluginConfig = ''

          " Use tab for trigger completion with characters ahead and navigate.
          inoremap <silent><expr> <TAB>
            \ coc#pum#visible() ? coc#pum#next(1) :
            \ CheckBackspace() ? "\<TAB>" :
            \ coc#refresh()
          inoremap <expr><S-TAB> coc#pum#visible() ? coc#pum#prev(1) : "\<C-h>"

          " Make <CR> to accept selected completion item or notify coc.nvim to format.
          inoremap <silent><expr> <CR>
            \ coc#pum#visible() ? coc#pum#confirm()
            \: "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"

          function! CheckBackspace() abort
            let col = col('.') - 1
            return !col || getline('.')[col - 1]  =~# '\s'
          endfunction

          " Use <C-space> to trigger completion.
          inoremap <silent><expr> <C-space> coc#refresh()

          " Use `[g` and `]g` to navigate diagnostics.
          nmap <silent> [g <Plug>(coc-diagnostic-prev)
          nmap <silent> ]g <Plug>(coc-diagnostic-next)

          " GoTo code navigation.
          nmap <silent> gd <Plug>(coc-definition)
          nmap <silent> gy <Plug>(coc-type-definition)
          nmap <silent> gi <Plug>(coc-implementation)
          nmap <silent> gr <Plug>(coc-references)

          " Highlight the symbol and its references when holding the cursor.
          autocmd CursorHold * silent call CocActionAsync('highlight')

          " Symbol renaming.
          nmap <leader>rn <Plug>(coc-rename)

          " Formatting selected code.
          xmap <leader>f  <Plug>(coc-format-selected)
          nmap <leader>f  <Plug>(coc-format-selected)

          " Remap keys for applying code actions at the cursor position.
          nmap <leader>ac  <Plug>(coc-codeaction-cursor)
          " Remap keys for apply code actions affect whole buffer
          nmap <leader>as  <Plug>(coc-codeaction-source)
          " Apply the most preferred quickfix action to fix diagnostic on the current line
          nmap <leader>qf  <Plug>(coc-fix-current)

          " Add `:Format` command to format current buffer.
          command! -nargs=0 Format :call CocActionAsync('format')

          " Add `:Fold` command to fold current buffer.
          command! -nargs=? Fold :call CocAction('fold', <f-args>)

        '';
      };

      plugins = with pkgs.vimPlugins; [ coc-snippets coc-vimtex ];

    };
  };
}
