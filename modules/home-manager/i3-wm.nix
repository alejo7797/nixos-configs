{ pkgs, lib, config, ... }: let

  cfg = config.myHome.i3;

in {

  options.myHome.i3.enable = lib.mkEnableOption "i3 configuration";

  config = lib.mkIf cfg.enable {

  };
}
