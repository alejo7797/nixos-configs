{ pkgs, lib, config, ... }: {

  options.myHome.zsh.enable = lib.mkEnableOption "user zsh configuration";

  config = lib.mkIf config.myHome.zsh.enable {

    # Configure zsh.
    programs.zsh = {
      enable = true;

    };

  };

}
