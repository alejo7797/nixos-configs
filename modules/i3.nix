
{ pkgs, lib, config, ... }: {

  options.myHome.zsh.enable = lib.mkEnableOption "i3 configuration";

  config = lib.mkIf config.myHome.i3.enable {



  };
}
