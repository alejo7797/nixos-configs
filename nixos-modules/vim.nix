{ pkgs, lib, config, ... }: {

  options.myNixOS.vim.enable = lib.mkEnableOption "vim";

  config = lib.mkIf config.myNixOS.vim.enable {

    # Install vim.
    programs.vim = {
      enable = true;
      package = pkgs.vim-full;
    };

    # And set it as default.
    environment.variables = {
      DIFFPROG = "vimdiff";
      EDITOR = "vim";
    };

  };

}
