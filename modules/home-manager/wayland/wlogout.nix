{ pkgs, lib, config, ... }: {

  options.myHome.wlogout.enable = lib.mkEnableOption "wlogout";

  config = lib.mkIf config.myHome.wlogout.enable {

    # Install wlogout.
    programs.wlogout.enable = true;

  };
}
