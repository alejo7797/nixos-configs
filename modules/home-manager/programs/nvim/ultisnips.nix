{ pkgs, lib, config, ... }: {

  options.myHome.neovim.ultisnips.enable = lib.mkEnableOption "ultisnips";

  config = lib.mkIf config.myHome.neovim.ultisnips.enable {

    programs.neovim.plugins = with pkgs.vimPlugins; [
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
