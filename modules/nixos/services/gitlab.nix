{
  lib,
  config,
  ...
}:

let
  cfg = config.myNixOS.gitlab;
in

{
  options.myNixOS.gitlab.enable = lib.mkEnableOption "GitLab Community Edition";

  config = lib.mkIf cfg.enable {



  };
}
