{
  lib,
  config,
  ...
}:

let
  cfg = config.myHome.ssh;
in

{
  options.myHome.ssh.enable = lib.mkEnableOption "SSH configuration";

  config = lib.mkIf cfg.enable {

    programs.ssh = {
      enable = true;

      matchBlocks = {
        "*.srcf.net" = {
          user = "ae433";
        };

        "abel" = {
          user = "epelde";
        };

        "patchouli" = {
          port = 21055;
        };

        "git.patchoulihq.cc" = {
          port = 21055;
        };

        "koakuma" = {
          port = 51901;
        };
      };
    };
  };
}
