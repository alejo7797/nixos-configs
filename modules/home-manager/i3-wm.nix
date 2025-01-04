{ pkgs, lib, config, ... }: {

  options.myHome.i3.enable = lib.mkEnableOption "i3 configuration";

  config = lib.mkIf config.myHome.i3.enable {

  };
}
