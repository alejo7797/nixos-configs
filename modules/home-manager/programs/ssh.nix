{
  lib,
  config,
  pkgs,
  ...
}:

let
  cfg = config.myHome.ssh;
in

{
  options.myHome.ssh.enable = lib.mkEnableOption "SSH configuration";

  config = lib.mkIf cfg.enable {



  };
}
