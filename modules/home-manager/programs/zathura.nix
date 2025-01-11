{ pkgs, lib, config, ... }: let

  cfg = config.myHome.zathura;

in {

  options.myHome.zathura.enable = lib.mkEnableOption "Zathura configuration";

  config.programs.zathura = lib.mkIf cfg.enable {

    # Configure Zathura.
    enable = true;

    options = {
      selection-clipboard = "clipboard";
      guioptions = "shv";
    };

  };
}
