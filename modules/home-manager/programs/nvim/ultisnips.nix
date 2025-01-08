{ pkgs, lib, config, ... }: let

  cfg = config.myHome.neovim.ultisnips;

in {

  options.myHome.neovim.ultisnips.enable = lib.mkEnableOption "ultisnips";

  config = lib.mkIf cfg.enable {

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
