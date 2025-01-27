{
  lib,
  config,
  ...
}:

let
  cfg = config.myNixOS.minecraft;
in

{
  options.myNixOS.minecraft.enable = lib.mkEnableOption "my personal Minecraft server";

  config = lib.mkIf cfg.enable {



  };
}
