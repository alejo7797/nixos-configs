{
  programs.ssh = {

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
}
