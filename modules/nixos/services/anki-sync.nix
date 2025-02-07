{
  lib,
  config,
  ...
}:

let
  cfg = config.myNixOS.anki-sync;
in

{
  options.myNixOS.anki-sync.enable = lib.mkEnableOption "Anki Sync Server";

  config = lib.mkIf cfg.enable {

  };
}
