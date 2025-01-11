{ pkgs, lib, config, ... }:

let
  cfg = config.myNixOS.vim;
in

{
  options.myNixOS.vim.enable = lib.mkEnableOption "Vim";

  config = lib.mkIf cfg.enable {
    # Install vim.
    programs.vim.enable = true;

    # And set it as default.
    environment.variables = {
      DIFFPROG = "vimdiff";
      EDITOR = "vim";
    };
  };
}
