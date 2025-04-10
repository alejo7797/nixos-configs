{ config, lib, ... }:

let
  cfg = config.my.laptop;
in

{
  options.my.laptop.enable = lib.mkEnableOption "laptop bundle";

  config = lib.mkIf cfg.enable {

    my.desktop.enable = true;

  };
}
