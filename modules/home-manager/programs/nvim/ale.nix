{ pkgs, lib, config, ... }: {

  options.myHome.neovim.ale.enable = lib.mkEnableOption "ALE";

  config = lib.mkIf config.myHome.neovim.ale.enable {

    programs.neovim.plugins = with pkgs.vimPlugins; [
      {
        plugin = ale;
        config = ''
          " Use specific linters for these filetypes.
          let g:ale_linters = {
          \   'python': ['flake8'],
          \   'c': ['clangd'],
          \   'tex': ['chktex'],
          \}

          " Configure fixers.
          let g:ale_fixers = {
          \   '*': ['remove_trailing_lines', 'trim_whitespace'],
          \   'html': ['prettier'],
          \   'css': ['prettier'],
          \   'scss': ['prettier'],
          \   'javascript': ['standard'],
          \   'sh': ['shfmt'],
          \   'python': ['black'],
          \   'c': ['clang-format', 'clangtidy'],
          \   'tex': ['latexindent'],
          \   'bib': ['bibclean'],
          \   'nix': ['nixfmt', 'trim_whitespace'],
          \}

          " ALEFix files on save.
          let g:ale_fix_on_save = 1

          " Except for the following filetypes.
          let g:ale_fix_on_save_ignore = {
          \   'nix': ['nixfmt'],
          \}

          " Desired shell script formatting.
          let g:ale_sh_shfmt_options = '-i 4'

          " Stop latexindent from creating log files in the working directory.
          let g:ale_tex_latexindent_options = '-y="defaultIndent:'''    '''" -c /tmp'
        '';
      }
    ];
  };
}
