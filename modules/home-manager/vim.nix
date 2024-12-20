{ pkgs, lib, config, ... }: {

  options.myHome.vim.enable = lib.mkEnableOption "vim configuration";

  config = lib.mkIf config.myHome.vim.enable {

  };
}
